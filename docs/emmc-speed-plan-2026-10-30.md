# eMMC speed plan (2026-10-30)

Goal: run the SM-T585 eMMC (mmc0, `13540000.mmc`) at HS200 instead of legacy 25 MHz.
Scope: kernel DT (and, only if needed, `dw_mmc-exynos`). U-Boot stays at its current
HS200/HS400-off config.

## Facts (read on r13, 2026-10-30)

- `debugfs mmc0/ios`: 25 MHz, timing 0 (legacy), 8 bit, signal 1.80 V, vdd 3.3 V.
- Supplies: vmmc = LDO26 at 3.3 V (range 1.8–3.375 V), vqmmc = LDO27 at 1.8 V.
- CIU clock (`dout_mif_cmu_fsys_mmc0`) = 199.875 MHz from a 799.5 MHz mux, `ciu-div = 3`
  → `bus_hz` ≈ 50 MHz: without `clock-frequency` the host can never exceed 50 MHz.
- Card: manfid 0x11, rev 0x7, date 08/2018, life_time 0x02, pre_eol 0x01;
  EXT_CSD DEVICE_TYPE = 0x57 (HS52, DDR52 1.8/3 V, HS200 1.8 V, HS400 1.8 V).
- Baseline: `dd if=/dev/mmcblk0p19 bs=1M count=512 iflag=direct` = 20.8 MB/s.
- Board DT mmc0 has no speed caps (`cap-mmc-highspeed` missing → legacy). Same in all mainline
  7870 boards.
- `dw_mmc-exynos` gives every host without an `mshc` alias `MMC_CAP_1_8V_DDR | 8_BIT`
  (caps index 0), so HS52 enables DDR52 too.
- Precedents with the same driver and the same `ciu-div 3`, `sdr-timing <0 4>`,
  `ddr-timing <2 4>`: Exynos7 espresso (HS200, `clock-frequency = <800000000>`), Exynos7885
  jackpotlte and Exynos850 (HS400 ES, `hs400-timing <0 2>`).
- Downstream gtaxl: HS200/HS400/ES, CIU 800 MHz, own `hs200-timing <3 0 3 0>` (drive phase 3),
  and on tuning failure it retries with stronger clock pin drive (`clk-drive-number = 6`,
  `fast-slew-rate-Nx` pinctrl states). Mainline has neither.
- Mainline HS200 uses `sdr-timing` plus the tuned sample; system suspend re-inits the card
  (eMMC has no KEEP_POWER), so retuning happens on resume.

## Hypotheses

- **E-A** The only blocker is DT: with `cap-mmc-highspeed` and `clock-frequency = <800000000>`
  the card runs DDR52; adding `mmc-hs200-1_8v` gives tuned HS200.
- **E-B** HS200 tuning fails or yields CRC errors with `sdr-timing <0 4>`: needs a different
  drive phase (downstream uses 3) or stronger clock pin drive.
- **E-C** HS400 ES works like on 7885/850 (`hs400-timing <0 2>`); U-Boot's HS400 failure came
  from its generic driver, not the board.

## Steps (DT only; one change per step)

Per step: DTB swap on /boot (keep `exynos7870-gtaxllte.dtb.good`), reboot, then
1. `ios` shows the expected timing/clock; dmesg has no `CRC`, `tuning`, `timeout`, `error`
   lines for mmc0;
2. sha256 of the untouched Android partition `mmcblk0p19` (3.3 GB) equals the baseline hash
   (read path correct over GBs);
3. 10 min eMMC + WiFi load (stress script pattern from the cpuidle work), dmesg clean;
4. one RTC s2idle cycle, 3 reboots;
5. throughput with the same `dd` as the baseline.

| # | Change | Predicted |
|---|---|---|
| S1 | `cap-mmc-highspeed`, `clock-frequency = <800000000>` | DDR52 (timing 8), 52 MHz, ~70–90 MB/s |
| S2 | + `mmc-hs200-1_8v` | HS200 (timing 9), 200 MHz, tuning OK, ~120–160 MB/s |
| S3 | (separate decision) + `mmc-hs400-1_8v`, `mmc-hs400-enhanced-strobe`, `hs400-timing <0 2>` | HS400 ES, ~200+ MB/s |

On failure: S2 tuning fails / CRC → E-B: try `sdr-timing <0 3>`, then a higher sd0 clk
`pin-drv`; if still failing, stay on S1.

## Results (2026-10-30)

- **S1 works:** DDR52 (timing 8), actual 49.97 MHz, `dd` 512 MiB direct read **72.7 MB/s**
  (baseline 20.8). p19 sha256 identical to the 25 MHz baseline (`e201f5c9…`), ~3.5 min
  eMMC + WiFi load, one RTC s2idle, 3 reboots: no mmc0 errors.
- **S2 fails:** card init and tuning succeed (`new HS200 MMC card`, 199.875 MHz), then every
  data read fails from sector 0 on (`I/O error`, endless reset/re-init), no rootfs → initramfs
  `fail_halt_boot`. Logs came from the initramfs log disk (`PMOS_LOGS`, USB mass storage) and
  the ACM debug shell (`/dev/ttyACM0`).
- Live sweep in the initramfs shell (static `kernel/tools/memtool` sent over `nc`):
  CLKSEL64 (0x135400A8) sample 0–7 × drive 4/3/2, one 4 KiB `O_DIRECT` read each: **all 24
  fail**; the reads reach the controller (IRQ 46 counts up). → Not a sample/drive phase
  problem (E-B as stated is refuted).
- Remaining hypotheses (driver work, not DT): (a) the 7870 needs downstream-only setup for
  200 MHz (`use-fine-tuning`/enable-shift, `bypass-for-allpass`, `ignore-phase`,
  `enable-ulp-mode`, `card-init-hwacg-ctrl`); (b) the data path fails at 200 MHz with IDMAC
  while tuning (128 B, below `dma_threshold` 512 → PIO) passes. TWRP's downstream kernel has
  no `/dev/mem`, so its register values could not be dumped.
- Decision: stay on S1 (DDR52) for now; HS200 needs a driver investigation.

## Risk / restore

- DT-only changes; a card init failure means no rootfs → boot fails → TWRP: copy back
  `exynos7870-gtaxllte.dtb.good` on the pmOS_boot vfat (loop offset method, see handoff
  2026-10-30 / TWRP restore pattern).
- A marginal mode could corrupt data on write. The read-verify (hash of p19) runs before the
  load test; on any CRC error stop and go back one step. The pmOS install can be redone with
  pmbootstrap; nothing on the tablet is irreplaceable.
- vmmc 2.85 V (old todo) is not needed for HS200 (eMMC VCC 2.7–3.6 V) and stays separate.
