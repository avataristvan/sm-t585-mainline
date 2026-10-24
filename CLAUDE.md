# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Guiding decisions

- **2026-09-19:** The newer **Samsung Galaxy Tab S6 Lite 2022, SM-P613** (`gta4xlveu`) runs
  current Android (unofficial LineageOS 23, XDA thread 4752160), installed by the user
  themselves — that tablet is **not** work for this repo.
- **2026-10-23:** This repo was explicitly reopened (no longer on hold) with a new goal: revive
  the old **SM-T585** as a **lean-Linux music device**. LineageOS 21 is too heavy for its 2 GB RAM.
  First target: **USB-MIDI pad controller** (f_midi gadget; needs only display, touch, USB device
  mode). Later ideas: synth/looper, Mixxx, Spotify player. Fallback if Linux fails: an older
  LineageOS (19.1/20) + apps like TouchDAW.

## Project

Mainline Linux on a **Samsung Galaxy Tab A 10.1 (2016) LTE, SM-T585**, codename **`gtaxllte`**
(board "Galaxy Tab A LTE 05", hw_rev 5/6), SoC **Exynos 7870** (8x Cortex-A53, Mali-T830MP1),
2 GB RAM, 1200x1920 panel. **Not** the SM-T580 (`gtaxlwifi`) — earlier notes assumed that variant.
Target userland: a slim postmarketOS later; for now a busybox initramfs.

The user is self-supporting this device — no vendor support; upstream help is best-effort.

## Current state (2026-10-23)

- **Mainline Linux 7.3 boots** on the device with our own board DTS
  `src/mainline/arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts` (passes `dtbs_check`;
  binding entry added in `samsung-boards.yaml`).
- Working: 8 CPUs, RAM, simpledrm framebuffer console (a8r8g8b8, colors correct), eMMC
  (25 MHz, HS200 not yet set), S2MPU05 PMIC regulators, keys + hall, USB gadget
  (NCM/RNDIS/ACM debug shell), ramoops@0x46e00000.
- In progress: touchscreen (`stmfts`, i2c1 @0x49).
- Missing upstream for this board: SoC audio (LPASS/I2S), SM5703 charger/fuel gauge, TMU/cpufreq,
  real DSI panel mode (hx8279 variant), Bluetooth/WiFi wiring. Full gap analysis:
  `device-dump/sm-t585/mainline-gap.md`.
- Priority after touch: **audio → Bluetooth → DSI panel**.

The device data (live DT, dmesg, kernel config, boot/recovery images, firmware blobs, sysfs
inventory) is in `device-dump/sm-t585/`; mainline boot logs in `device-dump/sm-t585-mainline-stage1/`.

## Repo layout

- `src/mainline/` — torvalds/linux clone (`--depth 1`), where the board DTS lives.
- `src/downstream-lineage-21/` — the working downstream kernel
  (github.com/Exynos7870-labs/android_kernel_samsung_exynos7870, branch `lineage-21`, running
  commit `e2426d3c1cef`); reference for drivers, pins, voltages
  (`exynos7870-gtaxllte_eur_open_05.dts` + `exynos7870-gtaxl_common.dtsi`).
- `kernel/` — our build tooling: `gtaxllte-stage1.config` (fragment on top of arm64 defconfig),
  `mkbootimg-gtaxllte.py`, `build-stage1.sh`, `initramfs/init`, `tools/acm-shell.py`,
  `tools/alsa/` (device-side audio helper scripts, served from `out/alsa/` via symlinks),
  `prebuilt/` (static aarch64 busybox), `out/` (boot images), `build/` (kernel build dir).
- `samsung galaxy tab a (2016)/` — LineageOS/TWRP/GApps zips for `gtaxllte`; contains a personal
  `invoice.pdf` that must stay out of any VCS.
- Git repo, public as github.com/avataristvan/sm-t585-mainline. `src/mainline` is a submodule
  (fork github.com/avataristvan/linux, branch `gtaxllte`), `src/downstream-lineage-21` a submodule
  of the upstream repo. Not in git (see `.gitignore`): the ROM folder incl. `invoice.pdf`,
  `kernel/build|out`, partition images, firmware blobs (`firmware-manifest.sha1` lists them),
  `docs/records/general/user/`, and the unredacted dump originals (`device-dump/.unredacted/`;
  the public dumps have serial numbers and MACs replaced).

## Build & flash

```bash
cd src/mainline
O=../../kernel/build
scripts/kconfig/merge_config.sh -m -O $O arch/arm64/configs/defconfig ../../kernel/gtaxllte-stage1.config ../../kernel/gtaxllte-builtin.config
make O=$O ARCH=arm64 LLVM=1 CC="ccache clang" olddefconfig
make -j8 O=$O ARCH=arm64 LLVM=1 CC="ccache clang" Image dtbs modules
sh ../../kernel/build-stage1.sh $O ../../kernel/prebuilt/busybox-1.37.0-r31-aarch64-static ../../kernel/out
```

Flash: only the BOOT partition (`/dev/block/mmcblk0p9`, 32 MiB) via `dd` from a root shell
(Lineage `adb root`, TWRP, or the stage-1 shell), then verify by reading back the hash. Always
confirm with the user before flashing.

Boot-image facts (S-Boot):
- Android header v0, page 2048, `header_version` slot = dt_size, kernel 0x10008000, ramdisk
  0x11000000, tags 0x10000100, `SEANDROIDENFORCE` trailer.
- DTB goes into a Samsung **DTBH** container: chip 7870, platform 0x50a6, subtype 0x217584da,
  hw_rev 0..0xff.
- S-Boot **replaces the kernel cmdline entirely** — the boot.img cmdline is ignored.
- Kernel + initramfs must fit 32 MiB: the full defconfig kernel (32.6 MB) does not; the trimmed
  Exynos-only config is ~19 MB.

Debug access on stage 1: USB NCM `telnet 172.16.42.1`, or USB-ACM shell (`/dev/ttyACM0`; without
host drivers via `kernel/tools/acm-shell.py` + pyusb). Kernel logs survive reboots in pstore.

## Recovery / safety

- Only BOOT is ever written. Bootloader, PARAM and RECOVERY (TWRP) stay untouched, so the
  device cannot be bricked by a failed boot test.
- Download mode: Vol-down + Home + Power. TWRP: Vol-up + Home + Power.
- Lineage boot image backup: `device-dump/sm-t585/partitions/boot.img`, also on the device at
  `/sdcard/boot-lineage.img`.
- Do **not** read `/sys/kernel/debug/clk/clk_summary` on the downstream kernel — it reboots the
  device instantly.
- `heimdall flash` reportedly hangs on this device family; use `dd` / TWRP instead.

## UART (last resort)

- No disassembly needed: microUSB jig with an ID-to-GND resistor; the SM5703 MUIC switches D+/D−
  to the AP UART. Standard Samsung values: **619 kΩ** (UART, boot off) / 523 kΩ (UART on).
  1.8V-capable USB-UART adapter, 115200 8N1. Unverified on hardware, and mainline has no SM5703
  MUIC driver.
- A 12-pin UART header on the mainboard (1.8V) exists but needs opening the device.

## Old pmOS port (background, 2026-09-10)

The postmarketOS `samsung-gtaxlwifi` port is archived, downstream 3.18 kernel, mostly untested;
the LTE variant panics with the wifi image. It is not the basis of this work.
Wiki: https://wiki.postmarketos.org/wiki/Samsung_Galaxy_Tab_A_10.1_(2016) — wiki/gitlab pages
are bot-gated for WebFetch; use the claude-in-chrome tools to read them.

## Related

ExoDeck (`~/workspace/ExoDeck-project/ExoDeck`), an Android Bluetooth HID app, is a possible
controller for this tablet once Bluetooth works.

## Notes for future sessions

- Don't fabricate kernel/boot status — confirm from the device, the dumps and the trees in `src/`.
- Bring-up steps (DTS, boot image, flash tests) stay interactive with the user; the dev-team is
  for self-contained driver work (e.g. SM5703 charger/fuel gauge, possibly audio).
- Take pin numbers and voltages from the downstream gtaxllte DTS, never from another 7870 board:
  several PMIC LDOs differ from j6lte (e.g. LDO35 is 1.8 V here).
