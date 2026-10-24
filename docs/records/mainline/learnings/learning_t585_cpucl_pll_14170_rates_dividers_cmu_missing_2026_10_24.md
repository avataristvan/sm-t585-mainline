id: learning_t585_cpucl_pll_14170_rates_dividers_cmu_missing_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792850174.372883
edges: [{"target_id": "learning_t585_lineage_cpu_dvfs_tables_in_sysfs_ect_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sboot_leaves_cpu_clusters_902mhz_clk_summary_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24", "edge_type": "related"}]
cue: Writing the CPUCL0/1 clock driver or OPP rates for the T585; mainline has no CMU_CPUCL0/1.
---

Observed: CPUCL0/1 PLL is type 14170 (ECT), 26 MHz osc, P/M/S per level in ect-pll_list.txt. The real rates of the low levels are not round: 902200, 838500, 756600, 448500, 342875 kHz (OPP table must use the true PLL rates). Divider table per level (ACLK PCLK ATCLK PCLKDBG CNTCLK RUN_MONITOR HPM PLL): 1 7 7 7 3 3 x 1 with HPM 4 (>=1586), 3 (902-1482), 2 (<=839). Mainline 7.3 has no CMU_CPUCL0/1 at all.
Cause: SoC clock design; missing driver upstream. Register offsets in downstream drivers/soc/samsung/pwrcal/S5E7870/S5E7870-cmusfr.h: CPUCL0_PLL_CON0 0x100, MUX_CPUCL0_PLL 0x200, MUX_CLKCMU_CPUCL0_SWITCH_USER 0x204, MUX_CLK_CPUCL0 0x208, DIVs 0x400-0x424.
Evidence: device-dump/sm-t585-cpufreq-ref/ect-pll_list.txt, the header above. Scope: chunk 3b.
