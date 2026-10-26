# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Guiding decisions

- **2026-09-19:** The newer **Samsung Galaxy Tab S6 Lite 2022, SM-P613** (`gta4xlveu`) runs
  current Android (unofficial LineageOS 23, XDA thread 4752160), installed by the user
  themselves — that tablet is **not** work for this repo.
- **2026-10-23 (superseded):** the repo was reopened to revive the old **SM-T585** as a
  lean-Linux *music* device (USB-MIDI pads first). Kept as history only.
- **2026-10-25:** the goal is a **general lean tablet**, not music-only
  (`domain_t585_general_lean_tablet_not_music_only_2026_10_25`): postmarketOS edge (systemd) +
  GNOME Mobile. Camera is out of scope (`domain_t585_camera_not_realistic_2026_10_25`).
- **2026-10-26:** kernel modules are allowed where sensible
  (`domain_kernel_modules_allowed_where_sensible_2026_10_26`); a broad modularization pass is pending.
- **2026-10-27:** everything except audio follows standard Linux interfaces; vendor quirks are
  smoothed out (`domain_t585_standard_linux_interfaces_except_audio_2026_10_27`). Audio keeps its own
  machine driver and routing.

## Project

Mainline Linux on a **Samsung Galaxy Tab A 10.1 (2016) LTE, SM-T585**, codename **`gtaxllte`**
(board "Galaxy Tab A LTE 05", hw_rev 5/6), SoC **Exynos 7870** (8x Cortex-A53, Mali-T830MP1),
2 GB RAM, 1200x1920 panel. **Not** the SM-T580 (`gtaxlwifi`). The user is self-supporting this
device — no vendor support; upstream help is best-effort.

Boot chain: **S-Boot → mainline U-Boot (in BOOT, mmcblk0p9) → systemd-boot on `pmOS_boot` (FAT32)
→ our kernel (EFI stub)**. **pmOS edge (systemd) + GNOME Mobile** lives in USERDATA (U-Boot maps it
as a disk via blkmap). The old stage-1 busybox initramfs flow still exists (debug, recovery) but is
secondary.

## Current state (2026-10-27)

- **Mainline Linux 7.3** with our board DTS
  `src/mainline/arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts` (`dtbs_check` clean; venv in
  `kernel/.venv`).
- **Working on HW:** 8 CPUs + cpufreq/DVFS, TMU thermal, eMMC (HS200/HS400 off in U-Boot; kernel
  25 MHz), S2MPU05 regulators, keys + hall, touch (`stmfts`), simpledrm console, USB gadget (ssh),
  audio (RT5659, jack detection), SM5703 fuel gauge + charger, Panfrost probes/renders.
- **Built, dtbs_check clean, NOT yet tested on HW** (test plans in `docs/`):
  WiFi (QCA9377, mmc1 + ath10k_sdio), DSI panel (own driver `panel-samsung-gtaxllte-hx8279d`,
  `docs/dsi-test-plan-2026-10-27.md`; step 2 = switchable panel power via
  `kernel/tools/mk-panelpwr-dtb.sh` + second boot entry), sensors (LIS2HH12 accel + CM3323 light,
  i2c7, `docs/sensors-test-plan-2026-10-27.md`), Bluetooth (QCA9377 `hci_qca` on serial1,
  `docs/bluetooth-test-plan-2026-10-27.md`).
- **Missing:** vibrator (SM5703 LDO2 regulator), grip sensors (no mainline driver), camera (out of
  scope), Panfrost `mali-supply`/OPP, nftables in the kernel.
- Next steps and ranked findings: `docs/records/FOCUS.md`, `docs/standard-interfaces-audit-2026-10-27.md`,
  latest handoff `docs/handoff-2026-10-26.md`. Gap analysis: `device-dump/sm-t585/mainline-gap.md`.

The device data (live DT, dmesg, kernel config, boot/recovery images, firmware blobs, sysfs
inventory) is in `device-dump/sm-t585/`; mainline boot logs in `device-dump/sm-t585-mainline-stage1/`.

## Repo layout

- `src/mainline/` — torvalds/linux clone (`--depth 1`), the board DTS and panel driver live here.
- `src/downstream-lineage-21/` — the working downstream kernel
  (github.com/Exynos7870-labs/android_kernel_samsung_exynos7870, branch `lineage-21`); reference for
  drivers, pins, voltages (`exynos7870-gtaxllte_eur_open_05.dts` + `exynos7870-gtaxl_common.dtsi`).
- `src/u-boot/` — U-Boot clone (not in git, see `.gitignore`).
- `uboot/` — U-Boot build: `build.sh` (GNU cross gcc `aarch64-linux-gnu-gcc`; clang gave a black
  screen), `gtaxllte.config`, `dts/` (board DTS + -u-boot.dtsi), `env/gtaxllte.env` (boot menu, powers
  off after 60 s), `out/u-boot-gtaxllte.img`.
- `pmos/` — own pmOS packages `device-samsung-gtaxllte` (deviceinfo, `kernel-cmdline.conf`, Home-key
  hwdb) and `linux-samsung-gtaxllte` (kernel config + `timeconst.bc`), symlinked into pmaports
  (`~/.local/var/pmbootstrap/cache_git/pmaports`). Update sha512sums in the APKBUILD after every edit.
- `kernel/` — build tooling: config fragments `gtaxllte-stage1.config` (on top of arm64 defconfig),
  `gtaxllte-builtin.config`, `gtaxllte-pmos.config` (EFI, systemd/BPF, zram, WiFi, DSI, sensors, BT),
  `mkbootimg-gtaxllte.py`, `build-stage1.sh`, `initramfs/` (init, rootfs-up, rootsh), `tools/`
  (`acm-shell.py`, `alsa/`, `host-nat.sh`, `mk-panelpwr-dtb.sh`, `rootfs/`), `prebuilt/` (static
  busybox), `out/` (boot images), `build/` (kernel build dir).
- `apps/` — small on-device apps (`pads`, SDL3 KMSDRM pad grid).
- `lineageOS/` — LineageOS/TWRP/GApps zips for `gtaxllte`; contains a personal `invoice.pdf` that
  must stay out of any VCS.
- Git repo, public as github.com/avataristvan/sm-t585-mainline. `src/mainline` is a submodule
  (fork github.com/avataristvan/linux, branch `gtaxllte`), `src/downstream-lineage-21` a submodule
  of the upstream repo. Not in git (see `.gitignore`): `lineageOS/` incl. `invoice.pdf`,
  `kernel/build|out`, `uboot/build|out`, `src/u-boot`, partition images, firmware blobs
  (`firmware-manifest.sha1` lists them), `docs/records/general/user/`, and the unredacted dump
  originals (`device-dump/.unredacted/`; the public dumps have serial numbers and MACs replaced).
  Commit plan: `docs/commit-plan-2026-10-27.md`.

## Build & flash

Kernel (also feeds the pmOS package config and the stage-1 image):

```bash
cd src/mainline
O=../../kernel/build
scripts/kconfig/merge_config.sh -m -O $O arch/arm64/configs/defconfig ../../kernel/gtaxllte-stage1.config ../../kernel/gtaxllte-builtin.config ../../kernel/gtaxllte-pmos.config
make O=$O ARCH=arm64 LLVM=1 CC="ccache clang" olddefconfig
make -j8 O=$O ARCH=arm64 LLVM=1 CC="ccache clang" Image dtbs modules headers  # headers: for the nolibc tools (pwrkeyd)
```

- **pmOS (normal path):** `pmbootstrap build linux-samsung-gtaxllte --src=...` and
  `device-samsung-gtaxllte`, then install; copy the merged config into
  `pmos/linux-samsung-gtaxllte/` and update its sha512. Image to USERDATA via U-Boot fastboot
  (reboot, hold **Vol-down** alone → menu → "Enter Fastboot Mode", 04e8:6602) with
  `pmbootstrap flasher flash_rootfs`; U-Boot itself: `sh uboot/build.sh` then
  `fastboot flash boot uboot/out/u-boot-gtaxllte.img`.
- **Stage-1 image (debug/recovery):** `sh kernel/build-stage1.sh $O kernel/prebuilt/busybox-1.37.0-r31-aarch64-static kernel/out`
  (numbered copies `boot-stage1-k<N>.img`).
- Only BOOT (`/dev/block/mmcblk0p9`, 32 MiB) and USERDATA are written; BOOT via `dd` from a root
  shell (TWRP, or a running system) with a read-back hash check. Always confirm with the user
  before flashing; root commands (sudo, dd, fastboot) run in the user's terminal.
- ssh into the running pmOS: `ssh -i ~/.ssh/id_ed25519_gtaxllte -o IdentitiesOnly=yes istvan@172.16.42.1`
  (USB NCM; the key is baked in via `pmbootstrap config ssh_keys`).
- Logs survive reboots in pstore (ramoops@0x46e00000); stage-1 also offers a USB-ACM shell
  (`kernel/tools/acm-shell.py` + pyusb).

Boot-image facts (S-Boot; apply to the U-Boot image and the stage-1 image alike):
- Android header v0, page 2048, `header_version` slot = dt_size, kernel 0x10008000, ramdisk
  0x11000000, tags 0x10000100, `SEANDROIDENFORCE` trailer.
- DTB goes into a Samsung **DTBH** container: chip 7870, platform 0x50a6, subtype 0x217584da,
  hw_rev 0..0xff.
- S-Boot **replaces the kernel cmdline entirely** — the boot.img cmdline is ignored (the pmOS
  cmdline comes from `kernel-cmdline.conf` via systemd-boot).
- BOOT is 32 MiB: the stage-1 kernel + initramfs must fit (full defconfig, 32.6 MB, does not;
  the trimmed Exynos-only config is ~19 MB). The pmOS kernel lives on `pmOS_boot`, not in BOOT.
- U-Boot has no charger driver: do not leave it idle in the menu.

## Recovery / safety

- Bootloader, PARAM and RECOVERY (TWRP) are never touched, so the device cannot be bricked by a
  failed boot test. If U-Boot cannot see its partitions or hangs: TWRP (Vol-up + Home + Power),
  `adb push` a U-Boot or stage-1 image, `dd` it to mmcblk0p9.
- Download mode: Vol-down + Home + Power.
- Lineage boot image backup: `device-dump/sm-t585/partitions/boot.img`, also on the device at
  `/sdcard/boot-lineage.img`.
- Do **not** read `/sys/kernel/debug/clk/clk_summary` on the downstream kernel — it reboots the
  device instantly.
- `heimdall flash` reportedly hangs on this device family; use `dd` / TWRP / U-Boot fastboot.

## UART (last resort)

- No disassembly needed: microUSB jig with an ID-to-GND resistor; the SM5703 MUIC switches D+/D−
  to the AP UART. Standard Samsung values: **619 kΩ** (UART, boot off) / 523 kΩ (UART on).
  1.8V-capable USB-UART adapter, 115200 8N1. Unverified on hardware, and mainline has no SM5703
  MUIC driver.
- A 12-pin UART header on the mainboard (1.8V) exists but needs opening the device.

## Old pmOS port (background, 2026-09-10)

The earlier postmarketOS `samsung-gtaxlwifi` port (downstream 3.18 kernel) is archived and not the
basis of this work; the current pmOS uses our own packages in `pmos/`. Wiki:
https://wiki.postmarketos.org/wiki/Samsung_Galaxy_Tab_A_10.1_(2016) — wiki/gitlab pages are
bot-gated for WebFetch; use the claude-in-chrome tools to read them.

## Related

ExoDeck (`~/workspace/ExoDeck-project/ExoDeck`), an Android Bluetooth HID app, is a possible
controller for this tablet once Bluetooth works.

## Notes for future sessions

- Don't fabricate kernel/boot status — confirm from the device, the dumps and the trees in `src/`.
- Bring-up steps (DTS, boot image, flash tests) stay interactive with the user; the dev-team is
  for self-contained driver work (e.g. SM5703 charger/fuel gauge, possibly audio).
- Take pin numbers and voltages from the downstream gtaxllte DTS, never from another 7870 board:
  several PMIC LDOs differ from j6lte (e.g. LDO35 is 1.8 V here).
