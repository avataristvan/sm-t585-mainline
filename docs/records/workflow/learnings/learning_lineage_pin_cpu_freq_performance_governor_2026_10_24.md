id: learning_lineage_pin_cpu_freq_performance_governor_2026_10_24
type: learning
area: workflow
perspective: the-coder
created: 1792850174.560077
edges: [{"target_id": "domain_t585_cpu_opp_table_asv7_2026_10_24", "edge_type": "related"}]
cue: Need to hold a fixed CPU frequency on Lineage (for measuring voltages or PLL) and no userspace governor exists.
---

Observed: Lineage has no userspace cpufreq governor. To pin a frequency, use the performance governor plus scaling_max_freq/scaling_min_freq per cluster (policy of cpu0 and cpu4). Lineage boot locks both clusters at 1482 MHz for 40 s, so wait before measuring.
Cause: downstream mp-cpufreq setup.
Evidence: used for the BUCK1 verification in domain_t585_cpu_opp_table_asv7_2026_10_24.
