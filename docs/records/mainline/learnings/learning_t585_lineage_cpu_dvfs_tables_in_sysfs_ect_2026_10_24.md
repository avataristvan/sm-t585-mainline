id: learning_t585_lineage_cpu_dvfs_tables_in_sysfs_ect_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792850173.797357
edges: [{"target_id": "learning_t585_sboot_leaves_cpu_clusters_902mhz_clk_summary_2026_10_24", "edge_type": "related"}]
cue: Need real per-chip CPU voltages or PLL data for OPP/cpufreq work on the T585 and the downstream dtsi values look like placeholders.
---

Observed: Lineage 3.18 on the T585 exposes the real per-chip CPU DVFS table at /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster{0,1}_volt_table, and the ECT tables under /sys/kernel/debug/ect/ (pll_list, dvfs_table, asv_table, ...).
Cause: The voltages in the downstream exynos7870.dtsi cpufreq node (900/800 mV, 1268750) are placeholders; the real values come from ECT plus ASV group 7 at runtime.
Evidence: dumps in device-dump/sm-t585-cpufreq-ref/ (e.g. ect-pll_list.txt). Scope: any OPP/voltage work on the T585.
