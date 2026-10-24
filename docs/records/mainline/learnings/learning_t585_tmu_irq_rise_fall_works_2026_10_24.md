id: learning_t585_tmu_irq_rise_fall_works_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792849366.258997
edges: [{"target_id": "domain_t585_soc_thermal_trips_81_91_115_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_tmu_exynos7870_mainline_support_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_thermal_followup_trips_cpufreq_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_polling_delay_1000_tmu_irq_edge_2026_10_24", "edge_type": "related"}]
cue: Doubting whether the TMU interrupt fires correctly (shows Edge in /proc/interrupts) or wanting to test trips without heating the SoC.
---

Observed: TMU interrupt path works on mainline 7870. The exynos7 set_trips window (RISE7_6+12 / FALL7_6+12, INTEN 0x110, INTPEND 0x118; layout identical to downstream TEM1456X/TEM1455X) fires exactly one IRQ on the rising crossing and one on the falling crossing (trip - hysteresis), no storm, although /proc/interrupts shows "Edge". Downstream DT uses interrupts = <0 435 0> (type none). Behaviour is correct; the reason for the "Edge" display was not investigated.
Cause: n/a (verification). Test method: DT trip temps are writable in sysfs (thermal_of sets THERMAL_TRIP_FLAG_RW_TEMP): echo 35000 > trip_point_0_temp, 8x busy loops (reaches 41 C); IRQ count 1->2 on rise, 2->3 on falling to 32 C.
Evidence: thermal chunk 2, 2026-10-24, kernel #21 on hardware.
