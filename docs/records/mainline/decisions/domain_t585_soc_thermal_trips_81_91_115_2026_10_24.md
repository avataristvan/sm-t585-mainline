id: domain_t585_soc_thermal_trips_81_91_115_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792849366.067029
edges: [{"target_id": "domain_t585_tmu_exynos7870_mainline_support_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpu_opp_table_asv7_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cooling_maps_both_clusters_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_polling_delay_1000_tmu_irq_edge_2026_10_24", "edge_type": "related"}]
cue: Choosing or changing soc-thermal trip temperatures or polling delays in exynos7870.dtsi, or asking why there is no 76 C trip.
---

Decision: soc-thermal trips in exynos7870.dtsi = passive soc-alert0 81 C, passive soc-alert1 91 C (hysteresis 2 C each), critical 115 C unchanged; polling-delay-passive 250 ms, polling-delay 1000 ms.
Why: downstream gtaxl_common cooling levels 76/81/86/91/96 clip the CPU to 1690/1248/1248/546/546 MHz. 1690 MHz is the top OPP (cl0_max_support_idx 3), so 76 C throttles nothing; the real steps are 81 C (->1248) and 91 C (->546).
Scope: thermal chunk 2. The cooling maps bound to soc-alert0/1 exist in the board dts (see domain_t585_cooling_maps_both_clusters_2026_10_24, kernel #26). polling-delay 1000 ms stays for now (see domain_t585_polling_delay_1000_tmu_irq_edge_2026_10_24).
