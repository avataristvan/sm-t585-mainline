id: learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793322709.468391
edges: [{"target_id": "learning_t585_pmu_cpu_options_not_programmed_mainline_vs_downstream_syspwr_init_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30", "edge_type": "contradicts"}, {"target_id": "learning_t585_cpuidle_c2_freezes_s2idle_timekeeping_watchdog_cause_resolved_2026_10_30", "edge_type": "contradicts"}]
cue: You are enabling cpuidle C2 on the SM-T585 again, or see dw_mmc "Interrupt latency" warnings, a boot hang at ~14 s or a shutdown hang.
---

Observed: With PSCI C2 enabled from boot (package r11), the SM-T585 loses device interrupts under I/O. dw_mmc warns in a loop "Interrupt latency, state ... (watched ...)": the eMMC completion IRQ is latched in MINTSTS but the handler never runs, while hrtimers still fire. Boot hangs at ~14 s; a ~14 min run hung at shutdown. The earlier C2 tests (E3-E6) were short and mostly idle and did not show it.
Cause: Not established. Leading hypothesis: cpu0 (target of all SPIs) can be powered down at WFE or while coherent, because mainline leaves the PMU CPU options unprogrammed (see learning_t585_pmu_cpu_options_not_programmed_mainline_vs_downstream_syspwr_init_2026_10_30). The claim "C2 works on all 8 CPUs" of learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30 holds only for short idle runs; C2 is not stable. The watchdog cause of learning_t585_cpuidle_c2_freezes_s2idle_timekeeping_watchdog_cause_resolved_2026_10_30 is NOT resolved while C2 stays off.
Evidence: docs/cpuidle-plan-2026-10-29.md section "E7 result"; journals of the hung boots; main cd889a4.
