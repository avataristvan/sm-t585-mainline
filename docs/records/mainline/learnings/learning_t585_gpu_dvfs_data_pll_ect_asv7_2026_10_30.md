id: learning_t585_gpu_dvfs_data_pll_ect_asv7_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793377380.009683
edges: [{"target_id": "learning_t585_gpu_supply_is_buck2_shared_mif_int_disp_cam_not_buck3_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_gpu_pll_rate_table_and_devfreq_works_d1_d2_2026_10_30", "edge_type": "related"}]
cue: You implement Panfrost devfreq or a GPU OPP table / G3D clock rates on the SM-T585 (Exynos 7870).
---

Observed: GPU DVFS data for this chip. G3D_PLL is type 14180 (VCO 600-1200 MHz). PMS values from the ECT pll_list: 1001 MHz 4/154/0, 845 4/130/0, 728 4/112/0, 676 4/104/0, 545 13/545/1, 450 13/450/1, 343 13/343/1. ECT dvfs_g3d maximum is 1001 MHz; 1146/1246/1300 are disabled. ASV group 7, table v5 voltages: 912.5/818.75/750/731.25/675/625/600 mV (the downstream dmesg applied 12.5 mV less). Mainline declares G3D_PLL as pll_1417x without a rate table, and dout_g3d_bus / mout_g3d lack CLK_SET_RATE_PARENT, so GPU rates cannot be set yet.
Cause: Mainline clock driver lacks the 14180 PLL rate table and the rate-propagation flags.
Evidence: device-dump/sm-t585-cpufreq-ref/ect-*.txt; device-dump/sm-t585/proc/dmesg-boot.txt:385-394; docs/gpu-dvfs-plan-2026-10-30.md.
