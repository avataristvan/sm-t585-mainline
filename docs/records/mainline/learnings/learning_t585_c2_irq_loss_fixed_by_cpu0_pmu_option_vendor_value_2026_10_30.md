id: learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793341580.116153
edges: [{"target_id": "learning_t585_pmu_cpu_options_not_programmed_mainline_vs_downstream_syspwr_init_2026_10_30", "edge_type": "confirms"}, {"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "fixes"}, {"target_id": "learning_t585_cpuidle_c2_freezes_s2idle_timekeeping_watchdog_cause_resolved_2026_10_30", "edge_type": "confirms"}, {"target_id": "learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30", "edge_type": "confirms"}]
cue: You touch Exynos7870 cpuidle or PMU init, or prepare the C2 patches for upstream.
---

Observed: The C2 interrupt loss is caused by cpu0's bootloader PMU OPTION (0x01010109: USE_STANDBYWFE set, USE_SMPEN clear). Writing the vendor value 0x10010109 (downstream init_pmu_cpu_option: set SMPEN b28, STANDBYWFI b16, MEMPWRDOWN_FEEDBACK b3, SC_COUNTER b0; clear STANDBYWFE b24, SC_FEEDBACK b1) makes C2 stable on all CPUs; writing the bootloader value back hangs within ~40 s under eMMC+WiFi load (the reverting run reproduced the failure). The fix is exynos7870_pmu_init() in the exynos-pmu pmu_init hook, for all 8 CPUs.
Cause: cpu0's OPTION as left by the bootloader. Which of the two cpu0 bits (STANDBYWFE vs SMPEN) is decisive was not separated.
Evidence: docs/cpuidle-plan-2026-10-29.md "Debug plan 2 results" (F1-F5, F3b); src/mainline drivers/soc/samsung/exynos-pmu.c exynos7870_pmu_init (uncommitted at time of writing).
