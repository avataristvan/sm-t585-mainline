id: learning_t585_cpuidle_c2_freezes_s2idle_timekeeping_watchdog_cause_resolved_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793317612.981748
edges: [{"target_id": "learning_t585_s2idle_keeps_monotonic_clock_running_journald_udevd_watchdog_2026_10_29", "edge_type": "confirms"}, {"target_id": "learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "contradicts"}]
cue: You see journald/udevd watchdog restarts after s2idle on the SM-T585, or ask whether shipping PSCI C2 cpuidle fixes them.
---

Observed: With PSCI C2 enabled on all CPUs (test kernel #9, PMU notifier), s2idle freezes timekeeping. Cover closed: monotonic `PM: suspend entry` 304.9 s -> `exit` 310.5 s (~5.6 s) while the wall clock advanced ~122 s (NetworkManager timestamps). state1/s2idle usage counts per CPU (2 each). Same boot id, no watchdog restarts.
Cause: With a cpuidle driver and idle-states, s2idle enters the deepest state and timekeeping is suspended, so monotonic time no longer runs and WatchdogSec cannot fire. This confirms the earlier cause (no cpuidle driver -> monotonic clock keeps running). The journald/udevd watchdog restarts are therefore resolved once cpuidle C2 ships. Caveat: the sleep was only ~2 min, shorter than WatchdogSec=3min, but a frozen monotonic clock makes length irrelevant.
Evidence: docs/cpuidle-plan-2026-10-29.md, section "E5 result".
