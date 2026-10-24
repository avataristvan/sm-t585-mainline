id: domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792850692.908428
edges: [{"target_id": "learning_t585_cpucl_pll_14170_rates_dividers_cmu_missing_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_cpu_opp_table_asv7_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_thermal_followup_trips_cpufreq_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_tmu_clocked_by_cpucl0_gates_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24", "edge_type": "related"}]
cue: Adding or changing CPU clocks (CMU_CPUCL0/1) for cpufreq on the T585, or wondering why CPUCL gates are not registered.
---

Decision: CMU_CPUCL0 (0x10900000) and CMU_CPUCL1 (0x10800000) are added to the mainline fork, read-only. clk-exynos7870.c gets per cluster: the PLL (pll_1417x), three muxes (MUX_CPUCLx_PLL {oscclk, fout_pll}, MUX_SWITCH_USER {oscclk, gout_mif_cmu_cpuclx_switch}, MUX_CPUCLx {mout_pll, mout_switch_user}, select bit 12) and 10 dividers (0x400-0x424, 3 bit). NO gates are registered, so clk_disable_unused cannot touch CPUCL gates. CMU_MIF gets DIV/GATE CLKCMU_CPUCL0/1_SWITCH (0x458/0x45c, 0x858/0x85c, parent ffac_mif_mux_bus_pll_div2); the gates are CLK_IS_CRITICAL because they are the alternate CPU parent during PLL relock. New dt-binding IDs: MIF IDs appended 129-132 (MIF_NR_CLK 133) so existing numbers stay stable; CPUCL0/1 blocks with 14 IDs each. Binding yaml has cmu-cpucl0/1 compatibles with clocks oscclk + switch; dtsi nodes cmu_cpucl0/cmu_cpucl1. dtbs_check and dt_binding_check clean.
Why: cpufreq needs a CPU clock; read-only first validates the tree on hardware before any rate change (done, kernel #22, BOOT sha1 f20353d909a7f911e73ed083f08a56e352dc1b8a, #21 kept as kernel/out/boot-stage1-k21.img).
Scope: thermal chunk 3b (done 2026-10-24); chunk 3c adds the switching.
