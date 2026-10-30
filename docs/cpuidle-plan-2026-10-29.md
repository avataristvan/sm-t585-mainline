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

Stop criterion: E2 and E3 both hang → stop, record, fall back to "no cpuidle"
(watchdog restarts stay harmless).

## Safety / restore

- Test kernel per pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27
  (`/boot/vmlinuz` + DTB swap, `panic=5` in pmos.conf, `/boot/vmlinuz.good` = r10).
- Hang → user's Power+Vol-down reset; restore = copy back `vmlinuz.good` and the DTB.
- Root steps on the tablet: see CLAUDE.local.md. Nothing touches BOOT/USERDATA partitions.
