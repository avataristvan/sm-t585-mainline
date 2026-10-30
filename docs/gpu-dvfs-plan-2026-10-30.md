# GPU DVFS plan (2026-10-30)

Goal: let Panfrost scale the Mali-T830 (`gpu@11400000`) between 343 and 1001 MHz instead of
running fixed at the bootloader's 343 MHz. Scope: CMU_G3D clock driver (rate table, rate
propagation), board DTS (OPP table, `mali-supply`, cooling). No overclocking beyond 1001 MHz.

## Facts (desk research)

- Mainline now: Panfrost probes, `clock rate = 343000000`, "supply mali not found, using dummy
  regulator", no OPP table → no devfreq. GNOME Shell renders on Panfrost (`renderD128`) and
  scans out via exynos-drm.
- Downstream limits (`drivers/gpu/arm/t83x/r29p0/platform/exynos/gpu_exynos7870.c`):
  `GPU_MAX_CLOCK` = `GPU_MAX_CLOCK_LIMIT` = 1001, `GPU_MIN_CLOCK` = start = 343 MHz,
  throttling at temperature 1001 → 845 → 728 → 545 → 343.
- ECT (`device-dump/sm-t585-cpufreq-ref/ect-dvfs_table.txt`): `dvfs_g3d` max 1001000, min 343000;
  levels 1300/1246/1146 marked `(X)` (disabled), 1001…343 `(O)`. Dividers per level: G3D_BUS 0
  (÷1), G3D_APB 3 (÷4), the same for all levels.
- G3D_PLL is type **14180** downstream (VCO 600–1200 MHz, Fref 2–8 MHz, `pwrcal-pll.c`);
  mainline declares it `pll_1417x` with **no rate table** (read-only). Same FOUT formula
  (M·Fin / (P·2^S)), so a `PLL_35XX_RATE` table works. PMS from ECT `pll_list`:

  | MHz | P | M | S | VCO MHz |
  |---|---|---|---|---|
  | 1001 | 4 | 154 | 0 | 1001 |
  | 845 | 4 | 130 | 0 | 845 |
  | 728 | 4 | 112 | 0 | 728 |
  | 676 | 4 | 104 | 0 | 676 |
  | 545 | 13 | 545 | 1 | 1090 |
  | 450 | 13 | 450 | 1 | 900 |
  | 343 | 13 | 343 | 1 | 686 |

  (1146/1246/1300 would need VCO 1146/1246/1300 with S = 0; the last two exceed the 1418x VCO
  range.)
- Voltages, this chip (ASV group 7, table version 5):

  | MHz | downstream dmesg "ASV is" | ECT asv_table v5 group 7 |
  |---|---|---|
  | 1001 | 900000 | 912500 |
  | 845 | 806250 | 818750 |
  | 728 | 737500 | 750000 |
  | 676 | 718750 | 731250 |
  | 545 | 662500 | 675000 |
  | 450 | 612500 | 625000 |
  | 343 | 600000 | 600000 |

  The dmesg values are what downstream applied (ECT minus 12.5 mV per-chip adjustment);
  `GPU_VOLTAGE_OFFSET_MARGIN` 25 mV exists but is not used by default. Plan: use the ECT values
  (12.5 mV more margin).
- **Supply: BUCK2, shared.** The downstream GPU driver takes `regulator_get(NULL, "BUCK2")`
  (all r7p0…r29p0 variants, `CONFIG_MALI_DVFS=y` in the Lineage config), and the MIF, INT, DISP
  and CAM devfreq nodes all name `reg_name = "BUCK2"` too. BUCK2 is the shared
  MIF/INT/DISP/CAM/G3D rail; downstream it settles on the highest request. This contradicts the
  earlier record that named BUCK3 (`learning_t585_panfrost_probes_on_mainline_2026_10_24`,
  `todo_t585_panfrost_mali_supply_opp_table_2026_10_24`); BUCK3's consumer is unknown.
- Mainline has no MIF/INT devfreq: MIF and INT run at the bootloader's clocks (downstream
  initial: MIF 902 MHz → 712.5 mV, INT 400 MHz → 737.5 mV, CAM up to 775 mV). BUCK2 reads
  **775000 µV** on mainline now (`vdd_buck2`, always on, 0.5–1.3 V). → The GPU must never pull
  BUCK2 below 775 mV: GPU OPPs below 1001/845 MHz get the floor 775 mV.
- Clock tree (mainline `clk-exynos7870.c`): `gout_g3d_clk` (SET_RATE_PARENT) ← `dout_g3d_bus`
  (DIV, **no** SET_RATE_PARENT) ← `gout_g3d_mux` (SRP) ← `mout_g3d` (MUX, no SRP) ←
  `gout_g3d_mux_pll_con` ← `fout_g3d_pll`. A rate request on the core clock would stop at the
  divider. The bus clock (`gout_g3d_asyncs_d0_clk`) hangs off the same divider and follows the
  core clock, as downstream (BUS ÷1).
- Downstream switches `mout_g3d` to the 800 MHz `G3D_SWITCH` clock while it relocks the PLL
  (`dfsg3d_switches`); mainline `samsung_pll35xx_set_rate` relocks in place (as on Exynos5433
  with Panfrost OPPs upstream).
- Kernel config has `PM_DEVFREQ`, `DEVFREQ_GOV_SIMPLE_ONDEMAND`, `DEVFREQ_THERMAL`.

## Hypotheses

- **G-A** With a G3D_PLL rate table, SET_RATE_PARENT through divider and mux, an OPP table
  (ECT voltages, floor 775 mV) and `mali-supply = <&vdd_buck2>`, Panfrost devfreq scales
  343–1001 MHz, stable.
- **G-B** Relocking the PLL in place while the GPU runs causes job faults/hangs → needs the
  downstream switch-clock dance (clock notifier reparenting `mout_g3d` during the relock).
- **G-C** BUCK2 is the GPU rail (from code). If it were BUCK3, 1001 MHz at BUCK3 ≈ 769 mV would
  fault within seconds.
- **G-D** The GNOME slowness is GPU-bound: frame times drop noticeably at 1001 MHz.

## Steps (one change per step)

Per step: kernel/DTB swap on /boot (keep `.good`), reboot, then dmesg clean of panfrost faults,
kmscube + GNOME use, `vdd_buck2` voltage readback, temperature.

| # | Change | Predicted |
|---|---|---|
| D1 | Clock driver only: G3D_PLL rate table, SRP on `dout_g3d_bus` and `mout_g3d`. No OPP. Manual test via a debugfs/clk test path is not available → verify at boot that the rate stays 343 and nothing changed | identical behaviour, no new clk warnings |
| D2 | DTS: OPP table 343…728 MHz only (all at 775 mV floor), `mali-supply = <&vdd_buck2>` | devfreq appears (`/sys/class/devfreq/11400000.gpu`), scales 343–728 under load, BUCK2 stays 775 mV, no faults (tests G-B at low risk: no voltage change) |
| D3 | + 845 (818.75 mV) and 1001 MHz (912.5 mV) | BUCK2 follows (775 → 912.5 mV), kmscube/GNOME stable at 1001 (G-C) |
| D4 | GPU cooling: `#cooling-cells` on the GPU, map into the soc-thermal trips (81 °C → cap 845, 91 °C → 545) | throttles under sustained load, as downstream |
| D5 | Measure: kmscube fps and a GNOME swipe at fixed 343 vs 1001 (`userspace` governor or min/max_freq) | G-D: ~2–3× fps on GPU-bound content |

On failure: D2 faults on rate switches → G-B: implement the switch-clock reparent and retry;
D3 faults at 845/1001 only → voltage: try the +25 mV margin, else cap at 728.

## Results (2026-10-30)

- Test kernels need their own build dir with `CONFIG_MODULE_ALLOW_BTF_MISMATCH=y` and
  `LOCALVERSION=` (records `learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28`,
  `learning_t585_test_kernel_localversion_empty_reuse_package_modules_2026_10_29`); the first
  D1/D2 boots without it loaded no modules (BTF -22) → no panel → no GDM.
- **D1 as predicted:** GPU stays at 343 MHz, no clk warnings, BUCK2 775 mV.
- **D2 works:** devfreq `11400000.gpu` (simple_ondemand, 343–728 MHz). About 1 min of GNOME use:
  379 transitions, 0 job faults / sched timeouts, BUCK2 stays 775 mV, 59 °C. Time share: 728 MHz
  ~68 %, 343 MHz ~17 %. → G-B (in-place PLL relock) refuted for these levels; the GPU is the
  bottleneck in GNOME (G-D likely), so D3 is worth it.
- **D3 works** (r16 kernel + D3 DTB): all 7 levels 343–1001 MHz; BUCK2 follows to 912.5 mV at
  1001 MHz (confirms G-C: BUCK2 is the GPU rail). About 1 min GNOME use: 312 transitions,
  0 job faults, 1001 MHz ~66 % of the time, SoC 50 °C. User: "flüssiger" (smoother).
  `stmfts … error code 0x0dec00d0ba` lines appear in every boot since r15 (10–17 per boot),
  unrelated to the GPU (touch, known open item).
- **D4 works:** `#cooling-cells` on the GPU and `<&gpu 0 1>` / `<&gpu 1 4>` in the soc-thermal
  maps (81 / 91 °C, next to both CPU clusters): cooling device `devfreq-11400000.gpu`
  (max_state 6) is bound to both trips. Forcing `cur_state` 1 / 4 / 0 caps `max_freq` at
  845 / 545 / 1001 MHz. Not tested with real heat.
- D5 dropped: devfreq residency (1001 MHz ~66 %) and the user's impression ("lock/unlock
  animation smooth, before a slideshow") answer G-D.
- Side finding, not GPU: GDM starts at ~19 s, exynos-drm binds only at ~24 s (decon waits for
  the deferred-probe timeout). GNOME Shell then finds no outputs ("primaryMonitor is null") and
  the screen stays black; `systemctl restart gdm` after DRM is up fixes it. The faster eMMC
  (HS200) exposes this race; the r15 boot only worked because GDM came late (97 s).
- `panfrost_gem_shrinker_scan` messages under use: GPU buffers get reclaimed (2 GB RAM).

## Risk / restore

- A wrong voltage on BUCK2 also hits MIF/INT (DRAM, interconnect): undervolt could crash the
  whole SoC, not just the GPU. Hence the 775 mV floor and the step order (frequency changes
  without voltage change first).
- Restore: `vmlinuz.good` / `exynos7870-gtaxllte.dtb.good` on pmOS_boot (boot menu or TWRP loop
  mount, as in the eMMC plan).
- No overclocking: 1146–1300 MHz are disabled in ECT, 1246/1300 exceed the PLL's VCO range.
