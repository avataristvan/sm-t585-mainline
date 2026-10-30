id: domain_t585_no_gpu_overclock_max_1001mhz_2026_10_30
type: domain
area: mainline
perspective: user
created: 1793377380.267507
edges: [{"target_id": "learning_t585_gpu_supply_is_buck2_shared_mif_int_disp_cam_not_buck3_2026_10_30", "edge_type": "derived_from"}, {"target_id": "learning_t585_gpu_dvfs_data_pll_ect_asv7_2026_10_30", "edge_type": "derived_from"}]
cue: You are tempted to add GPU OPPs above 1001 MHz (1146-1300) for the SM-T585.
---

Decision: No GPU overclocking (user, 2026-10-30). The GPU tops out at Samsung's 1001 MHz limit.
Why: The ECT disables 1146-1300 MHz; 1246 and 1300 exceed the 1418x PLL VCO range; the GPU voltage rail (BUCK2) is shared with MIF/INT.
Scope: GPU OPP table / Panfrost devfreq on the SM-T585 (gpu@11400000).
