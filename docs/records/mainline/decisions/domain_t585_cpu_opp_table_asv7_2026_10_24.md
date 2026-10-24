id: domain_t585_cpu_opp_table_asv7_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792850173.986509
edges: [{"target_id": "learning_t585_lineage_cpu_dvfs_tables_in_sysfs_ect_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_clusters_share_buck1_regulator_aggregation_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_cpucl_pll_14170_rates_dividers_cmu_missing_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_thermal_followup_trips_cpufreq_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_soc_thermal_trips_81_91_115_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cooling_maps_both_clusters_2026_10_24", "edge_type": "related"}]
cue: Writing the CPU OPP table (frequencies and BUCK1 voltages) for cpufreq-dt on the T585, mainline DTS.
---

Decision: T585 CPU OPP table (both clusters identical, this chip, ASV group 7), freq kHz -> BUCK1 uV: 1690000 1068750, 1586000 1006250, 1482000 956250, 1352000 906250, 1248000 868750, 1144000 825000, 1014000 781250, 902000 737500, 839000 712500, 757000 693750, 676000 668750, 546000 625000, 449000 606250, 343000 600000. Max 1690 MHz (2002/1924/1794 not used by Lineage). Note: the low levels' true PLL rates are not round (see the PLL learning), the OPP table must use them.
Why: measured ground truth instead of re-implementing ECT/ASV parsing. Verified on HW under Lineage: BUCK1 microvolts equals the table exactly at 1690/1248/902/546/343, no extra margin.
Scope: thermal chunk 3c OPP tables. Values are for this chip (ASV 7); other units may differ.
