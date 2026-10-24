id: domain_t585_cooling_maps_both_clusters_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792854971.533391
edges: [{"target_id": "domain_t585_soc_thermal_trips_81_91_115_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpu_opp_table_asv7_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24", "edge_type": "related"}]
cue: Changing or debugging CPU cooling maps on soc-thermal, or wondering why cooling-maps sit in the board dts and not the dtsi.
---

Decision: Cooling maps on soc-thermal bind both cpufreq cooling devices (cpu0 = cluster 0, cpu4 = cluster 1): soc-alert0 (81 C) states 0..4 (state 4 = 1248 MHz), soc-alert1 (91 C) states 4..11 (state 11 = 546 MHz). #cooling-cells = <2> on all 8 CPU nodes in exynos7870.dtsi, label soc_thermal on the zone. The cooling-maps live in the board dts because cooling states index the board's OPP tables from the top (14 OPPs, state 0 = 1690 MHz).
Why: mirrors downstream gtaxl_common freq_clip_max 1248 at 81 C and 546 at 91 C; step_wise ramps gradually inside the range instead of downstream's hard clip.
Scope: thermal chunk 3d, kernel #26 verified on HW (boot.img sha1 23da8bcd0e64b57ca819f9eb232f221cd53b1ac7 on BOOT; #25 kept as kernel/out/boot-stage1-k25.img). exynos7870.dtsi, exynos7870-gtaxllte.dts. dtbs_check: no new warnings (needs the dtschema venv, not installed globally).
