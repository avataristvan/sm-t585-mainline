id: learning_t585_gpu_pll_rate_table_and_devfreq_works_d1_d2_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793380729.028696
edges: [{"target_id": "learning_t585_gpu_dvfs_data_pll_ect_asv7_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_gpu_fixed_343mhz_slow_gnome_js_faults_bt_panel_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_gpu_supply_is_buck2_shared_mif_int_disp_cam_not_buck3_2026_10_30", "edge_type": "related"}, {"target_id": "todo_t585_panfrost_mali_supply_opp_table_2026_10_24", "edge_type": "related"}]
cue: Setting GPU rates or OPPs / Panfrost devfreq on the 7870, or considering pll_1418x for G3D.
---

Observed: GPU D1/D2 result. A G3D_PLL rate table plus CLK_SET_RATE_PARENT on dout_g3d_bus and mout_g3d (with CLK_SET_RATE_NO_REPARENT) keep 343 MHz at boot with no warnings. With OPPs 343-728 MHz at the 775 mV floor and mali-supply = vdd_buck2 (regulator-min 775 mV), Panfrost devfreq made 379 transitions in ~1 min of GNOME use, 0 job faults, BUCK2 at 775 mV, 59 C, ~68 % of the time at 728 MHz. pll_1418x must not be used for G3D: mainline's 1418x has a 9-bit MDIV and 545 MHz needs M=545; G3D stays pll_1417x.
Cause: In-place PLL relock is fine; the GPU is the GNOME bottleneck. This also supersedes the "rates cannot be set yet" part of the DVFS-data record.
Evidence: docs/gpu-dvfs-plan-2026-10-30.md.
