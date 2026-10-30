id: todo_t585_panfrost_mali_supply_opp_table_2026_10_24
type: todo
area: mainline
perspective: user
created: 1792876910.710767
edges: [{"target_id": "learning_t585_panfrost_probes_on_mainline_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_gpu_supply_is_buck2_shared_mif_int_disp_cam_not_buck3_2026_10_30", "edge_type": "contradicts"}, {"target_id": "learning_t585_gpu_pll_rate_table_and_devfreq_works_d1_d2_2026_10_30", "edge_type": "related"}]
cue: You enable Panfrost on the SM-T585 and dmesg warns "supply mali not found, using dummy regulator", deciding what the GPU needs next.
---

TODO: Wire the GPU rail and frequencies for Panfrost on the SM-T585. (1) Add mali-supply pointing to the BUCK3 regulator node (always on, 0.5-1.3 V in the downstream gtaxllte DTS), replacing the dummy regulator. (2) Add an OPP table for the gpu@11400000 node, with the frequencies the downstream gtaxllte DTS uses (the probe currently runs at 343 MHz). Take the voltages and frequencies from the downstream gtaxllte DTS, not from another 7870 board. Verify with dmesg after boot: no "using dummy regulator" warning, and kmscube still renders on Panfrost.
