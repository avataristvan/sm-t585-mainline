id: learning_t585_sboot_leaves_cpu_clusters_902mhz_clk_summary_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792850693.098359
edges: [{"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_cpucl_pll_14170_rates_dividers_cmu_missing_2026_10_24", "edge_type": "confirms"}, {"target_id": "learning_t585_lineage_cpu_dvfs_tables_in_sysfs_ect_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_cpufreq_dt_first_transition_undervolt_fix_2026_10_24", "edge_type": "related"}]
cue: Setting up CPU frequency switching on the T585 and wondering what rate and mux state the clusters start in under mainline.
---

Observed: S-Boot leaves BOTH clusters at 902.2 MHz from their PLL (P5 M347 S1), so mainline stage 1 has always run at 902.2 MHz (Lineage runs up to 1690). clk_summary rates match the ECT exactly: ACLK 451.1 (/2), PCLK/ATCLK/PCLKDBG 112.775 (/8), CNTCLK/RUN_MONITOR 225.55 (/4), HPM 225.55 (/4), DIV_PLL 451.1 (/2), DIV_1/DIV_2 /1. So the ECT dvfs_table divider values are raw register ratios (divisor-1). MUX_SWITCH_USER currently selects oscclk (26 MHz), while the MIF switch div outputs 799.5 MHz (bus PLL 1599/2, div /1).
Cause: S-Boot sets one fixed CPU operating point; mainline had no CPUCL clocks and left it untouched.
Evidence: kernel #22 on hardware (2026-10-24), clk_summary; device-dump/sm-t585-cpufreq-ref/ect-pll_list.txt. Scope for 3c: set SWITCH_USER to the MIF switch before using it as alternate parent, and probably divide 799.5 down.
