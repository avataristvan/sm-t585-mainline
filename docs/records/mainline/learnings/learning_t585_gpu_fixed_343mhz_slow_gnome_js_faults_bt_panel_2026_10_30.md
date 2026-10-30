id: learning_t585_gpu_fixed_343mhz_slow_gnome_js_faults_bt_panel_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793377380.526945
edges: [{"target_id": "learning_t585_gpu_dvfs_data_pll_ect_asv7_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_panfrost_probes_on_mainline_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_gpu_pll_rate_table_and_devfreq_works_d1_d2_2026_10_30", "edge_type": "related"}]
cue: GTK4/GNOME apps flicker or dmesg shows Panfrost "js fault INSTR_INVALID_ENC" or GPU sched timeouts on the SM-T585.
---

Observed: Mainline runs the GPU fixed at 343 MHz (1/3 of the 1001 MHz maximum); the user perceives GNOME as slow. Opening gnome-control-center's Bluetooth panel for the first time triggered 70 Panfrost "js fault INSTR_INVALID_ENC" messages plus two GPU sched timeouts with visible flicker (r15, 2026-10-30).
Cause: Not established. apk audit clean and shader cache freshly compiled, so not eMMC corruption. Suspected Mesa 26.2.5 Midgard compiler issue; test with GSK_RENDERER=cairo is pending with the user.
Evidence: dmesg on r15, 2026-10-30. The fixed 343 MHz follows from the missing rate table, see learning_t585_gpu_dvfs_data_pll_ect_asv7_2026_10_30.
