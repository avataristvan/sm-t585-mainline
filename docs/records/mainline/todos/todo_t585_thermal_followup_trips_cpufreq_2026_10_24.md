id: todo_t585_thermal_followup_trips_cpufreq_2026_10_24
type: todo
area: mainline
perspective: the-coder
created: 1792848643.575689
edges: [{"target_id": "domain_t585_tmu_exynos7870_mainline_support_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_exynos_thermal_selects_max8973_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_soc_thermal_trips_81_91_115_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_max8973_comes_from_defconfig_depends_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_tmu_irq_rise_fall_works_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpu_opp_table_asv7_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cooling_maps_both_clusters_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_polling_delay_1000_tmu_irq_edge_2026_10_24", "edge_type": "related"}]
cue: TMU trips and cooling maps are done; planning what remains of the thermal work (polling-delay 0, Edge IRQ display).
---

TODO: Thermal follow-up, remaining only: polling-delay 0 once the TMU IRQ is trusted (it still shows Edge in /proc/interrupts despite LEVEL_HIGH; see domain_t585_polling_delay_1000_tmu_irq_edge_2026_10_24).
DONE: (a) trips (domain_t585_soc_thermal_trips_81_91_115_2026_10_24) and REGULATOR_MAX8973 off (learning_t585_max8973_comes_from_defconfig_depends_2026_10_24); (b) cpufreq, schedutil default and CPU cooling maps on soc-alert0/1, kernel #26 (domain_t585_cooling_maps_both_clusters_2026_10_24).
Open question: one silent hang of kernel #16 (=y, with clock hack) was not reproduced in later boots.
