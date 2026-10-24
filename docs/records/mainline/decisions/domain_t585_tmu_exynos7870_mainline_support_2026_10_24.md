id: domain_t585_tmu_exynos7870_mainline_support_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792848642.609456
edges: [{"target_id": "learning_t585_tmu_clocked_by_cpucl0_gates_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_priority_thermal_battery_before_bt_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_soc_thermal_trips_81_91_115_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_tmu_irq_rise_fall_works_2026_10_24", "edge_type": "related"}]
cue: You are touching thermal/TMU support or temperature reads on the SM-T585 in mainline (exynos_tmu, tmu DT node, trip points).
---

Decision: The Exynos 7870 TMU (TEM1455X) is supported in mainline exynos_tmu.c as compatible "samsung,exynos7870-tmu" (SOC_ARCH_EXYNOS7870). The exynos7 ops are reused, with its own initialize/control: MUX_ADDR cleared with mask 0x7 (downstream 0x5); ptat (TRIMINFO bits 18-20) -> CONTROL1<<20; buf (TRIMINFO1 bits 18-21) -> CONTROL1<<12; one-point trim; THERM_TRIP_EN on; gain/vref not written (as downstream). DT: tmu@10130000, SPI 435, soc-thermal zone with only a critical trip at 115 C (downstream trigger_levels_7 HW trip), no cooling maps.
Why: user priority thermal + battery before BT (domain_priority_thermal_battery_before_bt_2026_10_24). Verified on hardware, kernel #20: 29-31 C idle, 38 C under 8-core load, back to 31 C.
Scope: mainline thermal bring-up (thermal chunk 1). Clocks: see learning_t585_tmu_clocked_by_cpucl0_gates_2026_10_24. Follow-ups: todo_t585_thermal_followup_trips_cpufreq_2026_10_24.
