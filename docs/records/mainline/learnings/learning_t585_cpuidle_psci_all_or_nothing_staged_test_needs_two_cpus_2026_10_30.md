id: learning_t585_cpuidle_psci_all_or_nothing_staged_test_needs_two_cpus_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793315636.910842
edges: [{"target_id": "learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30", "edge_type": "related"}]
cue: You are testing deep cpuidle states on one CPU at a time, or cpuidle-psci fails to probe or a single enabled CPU never enters the state.
---

Observed: Mainline cpuidle-psci is all-or-nothing: if any present CPU has no cpu-idle-states, probe fails with -ENODEV and rolls back all CPUs. For staged tests, put the state on all CPUs and register deep states with CPUIDLE_FLAG_OFF (debug hack), then enable per CPU via sysfs state1/disable. Loop to drv->state_count, NOT to the return value of dt_init_idle_driver(), which counts DT states only; that mistake left C2 active on all CPUs and hung boot. With only one CPU enabled and hrtimer broadcast (no MCT node), that CPU owns the broadcast hrtimer and gets -EBUSY, so it never enters; enable at least 2 CPUs.
Cause: cpuidle-psci probes all CPUs as one unit; without a per-CPU timer the broadcast owner cannot enter a state that stops its timer.
Evidence: docs/cpuidle-plan-2026-10-29.md (E1/E2/E3 result sections).
