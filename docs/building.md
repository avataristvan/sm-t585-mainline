# Building and installing

How to build the kernel, U-Boot and the postmarketOS image for the Samsung Galaxy Tab A 10.1
(2016) LTE, **SM-T585** (`gtaxllte`), and get them onto the device. Not the SM-T580 (WiFi model).

Boot chain:

```
S-Boot (stock, untouched) → mainline U-Boot (in BOOT, mmcblk0p9) → systemd-boot (FAT32 pmOS_boot)
  → Linux (EFI stub) → postmarketOS in USERDATA
```

Only two partitions are written: **BOOT** (U-Boot replaces the Android boot image) and
**USERDATA** (the postmarketOS disk image). The bootloader, PARAM and RECOVERY stay untouched,
so a failed boot can always be recovered from TWRP.

## Prerequisites

- An SM-T585 with TWRP in RECOVERY (Vol-up + Home + Power). Back up the stock BOOT partition
  before replacing it; with U-Boot in BOOT, Android no longer boots.
- Host (tested on Arch Linux): `clang`/`lld` (kernel), the GNU cross compiler
  `aarch64-linux-gnu-gcc` (U-Boot; clang-built U-Boot gave a black screen), `dtc`, `python3`,
  `pmbootstrap`, `fastboot`, `adb`.
- The repository with submodules:

  ```bash
  git clone --recurse-submodules https://github.com/avataristvan/sm-t585-mainline.git
  ```

  `src/mainline` is the kernel (branch `gtaxllte`), `src/downstream-lineage-21` the vendor-based
  reference kernel (not built). U-Boot is cloned separately:
  `git clone https://source.denx.de/u-boot/u-boot.git src/u-boot`.

## Kernel

The configuration is the arm64 defconfig plus three fragments: `gtaxllte-stage1.config` (SoC and
board drivers), `gtaxllte-builtin.config` (which defconfig modules stay built-in) and
`gtaxllte-pmos.config` (what postmarketOS, systemd and GNOME need).

```bash
cd src/mainline
O=../../kernel/build
scripts/kconfig/merge_config.sh -m -O $O arch/arm64/configs/defconfig \
    ../../kernel/gtaxllte-stage1.config ../../kernel/gtaxllte-builtin.config \
    ../../kernel/gtaxllte-pmos.config
make O=$O ARCH=arm64 LLVM=1 olddefconfig
make -j8 O=$O ARCH=arm64 LLVM=1 Image dtbs modules
```

The board device tree is `arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts`; check it with
`make O=$O ARCH=arm64 LLVM=1 CHECK_DTBS=y exynos/exynos7870-gtaxllte.dtb` (needs `dtschema`).

For the package, the merged `.config` is copied to
`pmos/linux-samsung-gtaxllte/config-samsung-gtaxllte.aarch64` and the sha512 in its `APKBUILD`
updated.

## postmarketOS packages and image

The device and kernel packages in `pmos/` are not in pmaports; link them into pmbootstrap's
pmaports checkout:

```bash
P=$(pmbootstrap config aports)
ln -s "$PWD"/pmos/device-samsung-gtaxllte "$P"/device/testing/
ln -s "$PWD"/pmos/linux-samsung-gtaxllte "$P"/device/testing/
```

Then `pmbootstrap init` with vendor `samsung`, device `gtaxllte`, UI `gnome-mobile`, systemd.
Build the kernel from this tree and create the image:

```bash
pmbootstrap build linux-samsung-gtaxllte --src="$PWD"/src/mainline
pmbootstrap build device-samsung-gtaxllte
pmbootstrap install
```

The device package puts the display drivers (`exynosdrm`, the panel) into the initramfs
(`modules-initfs`) so the panel is up before GDM starts; WiFi and Bluetooth firmware come from
the linux-firmware packages.

## U-Boot

```bash
sh uboot/build.sh          # → uboot/out/u-boot-gtaxllte.img
```

The script links the board files from `uboot/` into the U-Boot tree, builds `exynos-mobile` with
`uboot/gtaxllte.config` and wraps the result into a boot image the stock S-Boot accepts
(`kernel/mkbootimg-gtaxllte.py`: Android header v0, DTB in a Samsung DTBH container,
`SEANDROIDENFORCE` trailer). S-Boot replaces the kernel command line entirely; the real command
line comes from `pmos/device-samsung-gtaxllte/kernel-cmdline.conf` via systemd-boot.

## Installing

First install of U-Boot, from TWRP:

```bash
adb push uboot/out/u-boot-gtaxllte.img /tmp/
adb shell dd if=/tmp/u-boot-gtaxllte.img of=/dev/block/mmcblk0p9
# read back as many bytes as the image has and compare with sha1sum of the local file
adb shell "head -c $(stat -c %s uboot/out/u-boot-gtaxllte.img) /dev/block/mmcblk0p9 | sha1sum"
```

After that U-Boot can flash the rest itself: reboot, hold **Vol-down** to get the U-Boot menu,
choose "Enter Fastboot Mode", then

```bash
pmbootstrap flasher flash_rootfs         # postmarketOS image → USERDATA
fastboot flash boot uboot/out/u-boot-gtaxllte.img   # later U-Boot updates
```

U-Boot has no charger driver: do not leave the device sitting in its menu.

Later kernel updates do not need flashing: build the package and install it on the running
system (`pmbootstrap sideload` or `apk add`); mkinitfs and boot-deploy update the kernel,
initramfs and device tree on the FAT32 boot partition.

## Recovery

- Download mode: Vol-down + Home + Power. TWRP: Vol-up + Home + Power.
- If U-Boot or the boot partition is broken: from TWRP, `dd` a known-good U-Boot image (or the
  saved stock boot image) back to `mmcblk0p9`.
- If a new kernel does not boot: in TWRP, mount the FAT32 `pmOS_boot` from the USERDATA image
  and put back the previous `vmlinuz` / device tree.
- A debug path without postmarketOS exists: `kernel/build-stage1.sh` builds a boot image with a
  busybox initramfs and a USB serial shell (`kernel/tools/acm-shell.py`).
