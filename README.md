# Mainline Linux on the Samsung Galaxy Tab A 10.1 (2016), SM-T585

A 2016 Android tablet (Exynos 7870, 8× Cortex-A53, Mali-T830, 2 GB RAM, 1200×1920 DSI panel)
brought up on the **mainline Linux kernel** and running **postmarketOS + GNOME Mobile** as an
everyday lean tablet. No vendor kernel, no Android underneath.

```
S-Boot (stock) → mainline U-Boot → systemd-boot → Linux 7.3 (own branch) → postmarketOS edge + GNOME Mobile
```

The kernel work lives in the fork [avataristvan/linux, branch `gtaxllte`](https://github.com/avataristvan/linux/tree/gtaxllte),
included here as the submodule `src/mainline`. All patches on top of mainline at a glance:
[compare view](https://github.com/avataristvan/linux/compare/734bef548...gtaxllte).

## What works

| Area | State |
|---|---|
| CPUs | 8 cores, cpufreq/DVFS on both clusters (chip-specific ASV voltages), PSCI cpuidle C2, thermal throttling |
| Storage | eMMC in HS200, 129.5 MB/s sequential read (stock mainline: 25 MHz legacy, 20.8 MB/s) |
| Display | DSI panel with own panel driver, backlight, blank/unblank, clean hand-over from the boot framebuffer |
| GPU | Panfrost, devfreq 343–1001 MHz with thermal throttling (was fixed at 343 MHz) |
| Power | S2MPU05 PMIC, SM5703 charger + fuel gauge (GNOME battery, charge limit), s2idle suspend/resume via the cover |
| Input | Touchscreen (stmfts), keys, hall sensor (cover), accelerometer (auto-rotate), light sensor |
| Audio | Speakers, headset with jack detection, microphones (own machine driver for the RT5659 codec) |
| Connectivity | WiFi (QCA9377 over SDIO), Bluetooth (QCA9377 over UART), USB gadget networking/ssh |

Not done: vibrator, grip sensors, camera (out of scope), the display controller's SysMMU (runs in
bypass), nftables in the kernel, Bluetooth LE input devices.

## Case studies

Each larger problem was worked as a written plan: facts from the vendor kernel and the hardware,
hypotheses with predictions, one change per test boot, results. The plans are kept as written,
including the wrong turns.

- **eMMC: 20.8 → 129.5 MB/s** ([plan](docs/emmc-speed-plan-2026-10-30.md)). DDR52 was a device-tree
  change; HS200 tuned fine but every read timed out. A diagnostic kernel with runtime switches,
  driven from the initramfs debug shell, isolated the data timeout: the Exynos 7870 decodes the
  `TMOUT` register in Samsung's extended format, which mainline used only for ARTPEC-8.
  Fix: `mmc: dw_mmc-exynos: use the extended data timeout on Exynos7870`.
- **cpuidle: CPU0 hangs in C2** ([plan](docs/cpuidle-plan-2026-10-29.md)). With core power-down
  enabled, CPU0, which takes all device interrupts, hung within a minute of eMMC and WiFi load.
  Cause: the bootloader leaves CPU0's PMU option register different from CPU1–7 (SMP coherency
  bit clear); the kernel now programs all eight cores the way the vendor kernel does. A
  counter-test with only CPU0 set back reproduced the hang in ~40 s.
- **GPU frequency scaling** ([plan](docs/gpu-dvfs-plan-2026-10-30.md)). The GPU PLL had no rate table
  and the GPU's voltage rail turned out to be shared with the memory interface and interconnect,
  which mainline does not scale. The OPP table therefore keeps a 775 mV floor; voltages come from
  the chip's ASV calibration data.
- **Black screen after a faster boot** ([plan](docs/display-handover-plan-2026-10-30.md)). The faster
  eMMC exposed a race: GDM started before the panel existed. Three mechanisms overlapped (a
  SysMMU dependency that never resolves, the panel driver loading from the root filesystem, and
  simpledrm hand-over order). Fixed in the device tree and by loading the display stack from the
  initramfs; a counter-test reproduced the failure.
- **DSI panel hang** ([analysis](docs/dsi-hang-analysis-2026-10-27.md)). The first display commit froze
  the SoC without a serial console. The display controller started scanning out before the DSI
  link and the panel were initialised.

## Kernel patches (branch `gtaxllte`)

Grouped by subsystem; each commit is self-contained with a description of the problem and how it was tested.

- **Board**: device tree for the SM-T585 (`arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts`): PMIC,
  thermal, cpufreq OPPs, GPU OPPs, eMMC HS200, WiFi/BT, sensors, panel, battery, audio.
- **SoC (Exynos 7870)**: CPU cluster clocks, G3D PLL rates, audio PLL, TMU thermal, ADC, PMU CPU
  options for cpuidle, PSCI C2 idle state, extended MMC data timeout.
- **Display**: own panel driver (Himax HX8279-D / BOE), samsung-dsim fixes for the 7870
  (porches, PLL lock, FIFO bit, mode-before-commands), DECON start order, framebuffer hand-over.
- **Power**: Silicon Mitus SM5703 charger and fuel gauge driver (new), battery description, suspend fixes.
- **Audio**: S1402X audio mixer and RT5659 machine driver (new), RT5659 codec fixes, PL330 DMA reset.
- **Input**: stmfts touchscreen variant FTS1A096.
- **Generic**: cpufreq-dt first-transition fix.

None of these are upstream yet.

## Repository layout

| Path | Content |
|---|---|
| `src/mainline` | the kernel (submodule, fork branch `gtaxllte`) |
| `src/downstream-lineage-21` | the vendor-based LineageOS kernel, used as hardware reference (submodule) |
| `pmos/` | postmarketOS device and kernel packages |
| `kernel/` | config fragments, boot-image and debug tooling, diagnostic initramfs |
| `uboot/` | U-Boot board config, device tree and boot menu |
| `docs/` | plans, analyses and session handoffs; `docs/records/` holds decisions and lessons learned |
| `device-dump/` | data read from the stock device (device tree, dmesg, partition layout); serials and MACs redacted |

## Building

The kernel is built with clang from three config fragments on top of the arm64 defconfig, and
packaged with `pmbootstrap` (packages in `pmos/`). The steps, the boot-image format of the
stock bootloader and the recovery paths are in [docs/building.md](docs/building.md). Only the BOOT and USERDATA
partitions are written; the stock bootloader and recovery stay untouched, so a failed test boot
cannot brick the device.

## How this was built

This is a self-directed learning project. The work was done together with an AI coding
assistant (Anthropic's Claude, via Claude Code): research in the vendor kernel, debug plans,
code and commit messages were developed in that collaboration, hardware tests and decisions
were mine. Commits made with assistance carry a `Co-Authored-By: Claude` trailer. The
`docs/records/` folder is the shared memory of that process.

## License

The scripts, tools, packages and documentation in this repository are under the
[MIT License](LICENSE). Files with their own `SPDX-License-Identifier` (for example the U-Boot
device trees) keep that license, and the submodules keep theirs (the kernel is GPL-2.0).
`device-dump/` holds data read from a stock Samsung device; it is not covered by this license.
