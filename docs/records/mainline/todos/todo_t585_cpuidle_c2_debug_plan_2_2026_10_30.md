id: todo_t585_cpuidle_c2_debug_plan_2_2026_10_30
type: todo
area: mainline
perspective: agent
created: 1793322710.179149
edges: [{"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "derived_from"}, {"target_id": "learning_t585_pmu_cpu_options_not_programmed_mainline_vs_downstream_syspwr_init_2026_10_30", "edge_type": "related"}]
cue: You start a session on SM-T585 cpuidle or power work and need the next C2 debug steps.
---

TODO: cpuidle C2 debug plan 2, user present for every run: F1 C2 on cpu1-7 only with IRQs on cpu0 plus eMMC stress; F2 move the eMMC IRQ to a C2 CPU; F3 downstream OPTION value for cpu0; F4 full downstream syspwr_init PMU init. Details: docs/cpuidle-plan-2026-10-29.md "Debug plan 2".
