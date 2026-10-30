# cpuidle plan (2026-10-29)

Goal: PSCI cpuidle core power-down (C2) on the SM-T585. Two payoffs: s2idle freezes timekeeping
(no more journald/udevd watchdog restarts after >3 min, see
learning_t585_s2idle_keeps_monotonic_clock_running_journald_udevd_watchdog_2026_10_29) and lower
idle power. Out of scope: cluster power-down (CPD), SICD/AFTR/LPM (system power modes: wakeup masks,
pinctrl retention, idle-IP checks, downstream exynos-powermode).

## Facts (desk research)

- Firmware: PSCI **v0.1**, function IDs from DT (`cpu_suspend = 0xc4000001`), SMC. Mainline
  `cpuidle-psci` accepts that (it only needs `psci_ops.cpu_suspend`, set by the 0.1 DT path).
- Kernel now: `CONFIG_CPU_IDLE` off, no `idle-states` in `exynos7870.dtsi` → CPUs only WFI.
- Downstream (`exynos7870.dtsi`): one state per cluster, `arm,psci-suspend-param = <0x0010000>`
  (original format: StateType=powerdown, core level, id 0), entry 35 µs, exit 90 µs,
  min-residency 750 µs.
- Downstream C2 sequence (`cpuidle-exynos64.c` → `exynos-powermode.c` `enter_c2`): `cpu_pm_enter()`,
  then **the kernel clears `CPU_LOCAL_PWR_CFG` (0xf) in PMU `CPUx_CONFIGURATION`**
  (0x10480000 + 0x2000 + ((cluster<<2)|core)*0x80), then PSCI CPU_SUSPEND. On early wakeup
  (`cpu_suspend` returned without power loss) it sets 0xf back. On a real wakeup the kernel does
  not restore it (PMU/firmware does). Cluster down = `CPUSEQ_OPTION` bit 0, only non-boot cluster.
- Downstream hotplug (arm64 PSCI CPU_OFF) writes **no** PMU register → firmware powers cores
  down for CPU_OFF by itself.
- Mainline precedent: `drivers/soc/samsung/exynos-pmu.c` already has a CPU PM notifier
  (gs101: CPU_INFORM hints on CPU_PM_ENTER/EXIT and cpuhp). A 7870 variant would follow that.
- Timer: the per-core arch timer is lost on core power-down → state needs `local-timer-stop`.
  Mainline 7870 has **no MCT node**; arm64 then uses the hrtimer broadcast (one CPU holds the
  broadcast and stays out of the state). MCT (downstream SPI 102..113, `exynos4210-mct`) as a
  real broadcast device is a later option.
- s2idle: DT idle states get `enter_s2idle` (`dt_idle_states.c`), so `cpuidle_enter_s2idle` →
  `tick_freeze` → `timekeeping_suspend` once all CPUs are in.
- Baseline PMU read (read-only, python mmap of /dev/mem, `/tmp/pmucpu.py` on the tablet):
  all `cfg=0x8000000f`, `st=0x1006000f` (cpu running the script: `0x6000f` → bit 28 likely
  "in WFI"), L2/noncpu on, `CPUSEQ_OPTION=0` both clusters.

## Hypotheses

- **H-A** firmware powers the core down on CPU_SUSPEND by itself (as for CPU_OFF).
- **H-B** firmware needs the kernel to clear `CPU_LOCAL_PWR_CFG` first (downstream sequence);
  without it CPU_SUSPEND degrades to a WFI-like return (works, no power gain).
- **H-C** without the PMU write the core hangs or comes back at a wrong point (hang/reboot).

## Experiments (one variable each, in order)

| # | Change | Prediction | Discriminates |
|---|--------|-----------|---------------|
| E1 | none (stock r10): `echo 0 > cpu7/online`, read PMU, `echo 1` | st of cpu7 low nibble → 0 while offline, back to 0xf | confirms PMU status semantics + firmware-driven power-down for CPU_OFF |
| E2 | test kernel: `CPU_IDLE`, `ARM_PSCI_CPUIDLE`, DT state (downstream values + `local-timer-stop`) on **cpu4–7 only**; no PMU code | H-A: usage counters rise, sampled st of idle cpu4–7 shows power-down; H-B: counters rise, st never drops; H-C: hang/reboot (panic=5) | H-A vs H-B vs H-C |
| E3 | only if E2 = H-B or H-C: PMU CPU PM notifier for 7870 (CPU_PM_ENTER clears 0xf, EXIT/ENTER_FAILED sets it) | st drops while idle, wakeups normal | confirms H-B |
| E4 | state on all 8 CPUs | stable under load + idle, ssh/touch/audio fine | boot cluster OK |
| E5 | s2idle via cover, >3 min | no journald/udevd watchdog restart; dmesg shows timekeeping freeze/jump | payoff 1 |
| E6 | idle `current_now` (FG) screen off, r10 vs cpuidle, 5 min each | lower with cpuidle (size unknown) | payoff 2 |

### E1 result (2026-10-29, r10)

- cpu7 offline: `cfg 0x8000000f → 0x80000000`, `st 0x1006000f → 0x104b0000` → **firmware itself
  clears CPU_LOCAL_PWR_CFG on CPU_OFF** and the core powers down (st low nibble 0). Prediction met.
- cpu4–7 offline: additionally `CPUSEQ_OPTION(cl1) 0 → 1`, cl1 noncpu `0x8000f → 0x5e0000`,
  L2 `0x7 → 0x10080000` → firmware powers the whole non-boot cluster down when its last core goes.
- online again: cores back at `0x8000000f`/`st …f`, noncpu/L2 back on, but `CPUSEQ_OPTION(cl1)`
  **stays 1** (firmware does not reset it; downstream clears it in `cluster_up`). No dmesg errors.
- Meaning for E2: firmware does drive the PMU for CPU_OFF, so H-A is plausible, but downstream
  still writes the PMU before CPU_SUSPEND, so H-B stays open. E2 decides.

### E2 result, attempts 1+2 (2026-10-29/30)

- Attempt 1 (state on cpu4–7 only): `cpuidle-psci` did not register (`current_driver = none`).
  `psci_cpuidle_probe` is all-or-nothing; cpu0 without DT states → `-ENODEV` → full rollback.
  So all CPUs need the state; partial rollout has to go through sysfs `disable`.
- Attempt 2 (state on all 8 CPUs + debug hack meant to register deep states with
  `CPUIDLE_FLAG_OFF`): **early boot hang** (screen stays at U-Boot's `Booting: Label: blkmap`,
  no USB, no panic reboot, pstore empty after the TWRP restore). The hack was wrong: the loop ran
  to `ret` of `dt_init_idle_driver()` (= number of DT states, 1), not to `drv->state_count`, so
  C2 was **active** on all CPUs. Result: plain PSCI CPU_SUSPEND 0x10000 on all CPUs, no PMU
  write → early hang. Consistent with H-C; a broadcast-timer cause (`bc_hrtimer`,
  `local-timer-stop`) is not excluded yet.
- Restore: TWRP, `losetup -o $((2048*512))` on mmcblk0p23, vfat mount, copy `.good` back
  (E2 files kept as `vmlinuz.e2`, `exynos7870-gtaxllte.dtb.e2` on pmOS_boot).
- Next (attempt 3): fixed hack (`i < drv->state_count`); boot must equal WFI-only, then enable C2
  per CPU via sysfs, cpu7 first.

### E2 result, attempt 3 (2026-10-30, kernel #8, fixed hack)

- Boot normal, `psci_idle` registered, C2 `disable=1` on all CPUs → registration and broadcast
  setup (`bc_hrtimer`, oneshot mode, `tick_broadcast_mask ff`) are harmless.
- C2 enabled on cpu7 alone for 10 s: `usage=0`, no hang (cpu7 owns the hrtimer broadcast →
  `-EBUSY` → WFI).
- C2 enabled on cpu6+cpu7 for 10 s: `usage=0` both, PMU `cfg=0xf` both; shortly after,
  ping answers but ssh hangs at the banner → user reset; pstore empty.
- `usage`/`time` are counted only **after** the state returns, so `usage=0` + hang = a core
  entered C2 and never came back. **Verdict: H-C** (no wakeup without the PMU write), matching
  downstream (`exynos_cpu.power_down()` before CPU_SUSPEND) and mainline gs101 ("CPU_INFORM
  hints required in addition to the standard PSCI calls ... limitations in the el3mon firmware").

### E3 (kernel #9, built)

Debug notifier in `exynos-pmu.c` for `samsung,exynos7870-pmu`: CPU_PM_ENTER clears
`CPU_LOCAL_PWR_CFG` of the calling core (MPIDR-based offset, raw writel via `pmu_base_addr`),
CPU_PM_EXIT / ENTER_FAILED set it back. C2 still default-off. Test: enable cpu6+7, then all.
Prediction (H-B): `usage` rises, sampled PMU `st` of idle cores shows power-down, no hang.

### E3 result (2026-10-30, kernel #9) — H-B confirmed

- cpu6+7, 5 × 1.5 s: `usage` 53/73, `time` 2.0 s/4.0 s, PMU `st` sampled as off in up to ~80 %
  of samples; no hang. Prediction met.
- E4 folded in: all 8 CPUs, ~25 s incl. 3 s full load on 8 CPUs: every CPU enters and leaves
  C2 (usage 105..4121, residency 13–24 s each), PMU shows cores powered off, no RCU/lockup
  messages. cpu0 has many `above` (3085/4121: woken earlier than predicted, IRQ-heavy CPU).
- So: on this firmware, PSCI CPU_SUSPEND power-down works only if the kernel clears
  `CPU_LOCAL_PWR_CFG` first; with it, C2 is stable on both clusters.

### E5 result (2026-10-30, kernel #9, C2 on all CPUs)

- Cover closed → s2idle; monotonic `PM: suspend entry` 304.9 s → `exit` 310.5 s (~5.6 s) while
  wall clock advanced ~122 s (NetworkManager timestamps) → **timekeeping frozen in s2idle**.
  `state1/s2idle/usage=2` per CPU. Same boot id, no watchdog restarts (sleep was ~2 min, but
  with a frozen monotonic clock WatchdogSec can no longer fire).

### E6 result (2026-10-30, USB unplugged, screen off/gdm inactive, WiFi on)

| phase | C2 | I | P |
|---|---|---|---|
| off 4 min | disabled | −425 mA (sd 36) | 1.72 W |
| on 4 min | enabled | −417 mA (sd 25) | 1.69 W |
| off2 2 min | disabled | −427 mA (sd 38) | 1.72 W |

C2 saves ~8 mA (~2 %, within noise): core-only power-down; L2/noncpu and the SoC stay on.
The baseline of ~1.7 W with the screen off is the real power topic (separate investigation:
WiFi, panel/DSI supplies after blank, always-on regulators; CPD/SICD out of scope here).
Measurement pitfall: a script started with `setsid nohup` over ssh dies at logout (logind
session scope); use `systemd-run --unit=…`.

### E7 result: r11 with C2 from boot is NOT stable (2026-10-30)

- r11 (C2 on all CPUs from boot) ran ~14 min, then hung during shutdown (journal ends after
  `systemd-shutdown: Sending SIGTERM`, "Journal stopped"). The rebuilt r11 (same behaviour after
  /simplify) hung ~14 s into boot; after a reset the screen looped
  `dwmmc_exynos 13550000.mmc: Interrupt latency, state … (watched …)`.
- That warning (dw_mmc watchdog) means the eMMC completion interrupt is latched in MINTSTS but its
  handler never runs; hrtimers still fire. So with C2 a **device interrupt (SPI) is lost** —
  the earlier E3–E6 runs were mostly idle with little eMMC traffic, so it did not show.
- Recovery: TWRP, `cpuidle.off=1` added to `loader/entries/pmos.conf` (local workaround; the
  kernel package hook rewrites the file). Then r12: `CONFIG_CPU_IDLE` off again (config identical
  to r10); PMU notifier and DT state stay (inert without cpuidle).

### Desk research after E7: PMU CPU options differ from downstream

Downstream `pwrcal/S5E7870/S5E7870-syspwr.c` `syspwr_init()` (pm_init at boot) programs, which
mainline never does: per-CPU `CPUx_OPTION` (0x2008 + n*0x80) |= `USE_SMPEN` (b28),
`USE_STANDBYWFI` (b16), `USE_MEMPWRDOWN_FEEDBACK` (b3), `USE_SC_COUNTER` (b0), &= ~`USE_STANDBYWFE`
(b24), ~`USE_SC_FEEDBACK` (b1); `CPUx_DURATION0` fields; `CPUCLx_NONCPU_OPTION`;
`CPUCLx_L2_OPTION` (`USE_STANDBYWFIL2`, no auto flush/retention); `UP_SCHEDULER` |= 3.

Read on the running r11 (cpuidle off, read-only):

| reg | cpu0 | cpu1–7 | downstream wants |
|---|---|---|---|
| OPTION | `0x01010109` | `0x10010101` | SMPEN, STANDBYWFI, MEMPWRDOWN_FB, SC_COUNTER; no WFE |
| → SMPEN b28 | **0** | 1 | 1 |
| → STANDBYWFE b24 | **1** | 0 | 0 |
| → MEMPWRDOWN_FB b3 | 1 | **0** | 1 |
| DURATION0 | `0xffffffff` | cl0 `0xffffffff`, cl1 `0xffff0fff` | fields 0x3 at [11:8], [7:4] |
| L2_OPTION cl0/cl1 | `0x0` | | `USE_STANDBYWFIL2` |
| NONCPU_OPTION | `0x161` both | | SC_COUNTER, no SC_FEEDBACK |
| UP_SCHEDULER | `0x0` | | `0x3` |
| CPUSEQ_OPTION | `0` both (fresh boot) | | 0 except during cluster down |

cpu0 — the CPU all SPIs target by default — may be powered down on **WFE** (arm64 spinlock waits
use WFE) once LOCAL_PWR_CFG is cleared, and the PMU does not wait for SMPEN low.

## Debug plan 2 (next session, user present; each hang needs a reset)

Hypotheses:
- **H4** cpu0's bootloader OPTION (STANDBYWFE on, SMPEN off) lets the PMU power cpu0 down at a
  WFE or while still coherent → lost IRQ state / hang. Only cpu0 is affected.
- **H5** the missing downstream PMU init in general (MEMPWRDOWN_FEEDBACK on cpu1–7, durations,
  L2 option) makes C2 racy on any CPU.
- **H6** SPI wakeup from C2 is lost independent of the options (GIC/firmware), on any CPU that
  receives device IRQs.

Experiments (test kernel with `CONFIG_CPU_IDLE=y`, C2 default-off via the debug hack, enabled per
CPU through sysfs; eMMC stress e.g. `dd`/`find /` + `sync` loops, 10 min each, with
`cpuidle.off=1` kept as the boot fallback entry):

| # | Change | H4 predicts | H5 | H6 |
|---|---|---|---|---|
| F1 | C2 on cpu1–7 only, IRQs on cpu0 | stable | may hang | stable (no IRQ target in C2) |
| F2 | F1 + move the eMMC IRQ to cpu5 (`/proc/irq/N/smp_affinity`) | stable | may hang | hangs |
| F3 | write downstream OPTION for cpu0 only (devmem-style from a module param), C2 on all | stable | may hang | hangs |
| F4 | full downstream `syspwr_init` CPU/L2/NONCPU/UP_SCHEDULER init in exynos-pmu probe, C2 all | stable | stable | hangs |

Stop: F1+F2 hang → H6, compare downstream GIC handling (wakeup via PMU `INTR_SPREAD`,
`CPUCLx_INTR_SPREAD_USE_STANDBYWFI` in CMU) before more HW runs.

Stop criterion: E2 and E3 both hang → stop, record, fall back to "no cpuidle"
(watchdog restarts stay harmless).

### Debug plan 2 results (2026-10-30)

Load per run, 10 min: random 32 MiB `O_DIRECT` reads from mmcblk0 + 16 MiB `fsync` writes
(on the tablet), plus ~1.3–1.9 GB of ssh traffic over WiFi in both directions (from the host).
IRQ map: 47 = `13540000.mmc` (mmc0, eMMC), 45 = `13550000.mmc` (mmc1, WiFi SDIO; the r11 loop
was on this one), 46 = `13560000.mmc` (mmc2, SD).

| Run | Setup | Result |
|---|---|---|
| Control | r12, no cpuidle | stable, no new latency warning |
| F1 | C2 on cpu1–7, IRQs on cpu0 | stable, ~600k C2 entries |
| F2 | F1 + IRQ 45/47 on cpu5 | stable; cpu5 handled 2M+140k IRQs, ~270k C2 entries |
| F3 | C2 on all CPUs, IRQs on cpu0, cpu0 OPTION written to `0x10010109` at runtime | stable; cpu0 ~380k C2 entries |
| F3b | F3 with cpu0 OPTION written back to `0x01010109` | **hang after ~40 s** (pstore empty) |
| F4 | `exynos7870_pmu_init()` sets the downstream OPTION bits on all CPUs, C2 on all | stable; cpu0 ~370k C2 entries |
| F5 | F4 without the default-off hack (C2 from boot) | 3 reboots clean (journal stopped cleanly each time); load run stable; RTC-woken s2idle (`rtcwake -m freeze -s 60`) resumes, monotonic advanced 8 s over ~60 s, no watchdog timeouts |

Verdict: **H4 confirmed, H6 refuted** (a C2 CPU is woken by device SPIs fine, F2); H5 is not
needed beyond the cpu0 OPTION (cpu1–7 were stable with the bootloader values, F1). The
OPTION init goes into the exynos-pmu `pmu_init` hook. Which of the two cpu0 bits
(STANDBYWFE, SMPEN) is decisive is not separated; the vendor kernel sets both.

A single `dwmmc_exynos 13540000.mmc: Interrupt latency, state 1` at ~13.6 s of boot (right after
exynos-drm's deferred probe timeout) also appears without cpuidle (r12, and 6 of 84 older
boots) and is not a C2 symptom. The C2 symptom was the endless loop / hang.

## Safety / restore

- Test kernel per pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27
  (`/boot/vmlinuz` + DTB swap, `panic=5` in pmos.conf, `/boot/vmlinuz.good` = r10).
- Hang → user's Power+Vol-down reset; restore = copy back `vmlinuz.good` and the DTB.
- Root steps on the tablet: see CLAUDE.local.md. Nothing touches BOOT/USERDATA partitions.
