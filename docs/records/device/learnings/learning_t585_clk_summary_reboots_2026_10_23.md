id: learning_t585_clk_summary_reboots_2026_10_23
type: learning
area: device
perspective: agent
created: 1792769192.281225
edges: [{"target_id": "domain_target_device_sm_t585_2026_10_23", "edge_type": "related"}, {"target_id": "learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_pmu_regmap_cat_hangs_device_2026_10_23", "edge_type": "related"}, {"target_id": "learning_clk_summary_safe_on_mainline_dtschema_venv_2026_10_24", "edge_type": "related"}]
cue: You are about to read debugfs or sysfs files on the running SM-T585 to inspect clocks or GPIOs.
---

Observed: On the SM-T585 downstream 3.18 kernel, reading /sys/kernel/debug/clk/clk_summary reboots the device instantly. gpio debugfs and sysfs reads are safe.
Cause: not investigated.
Evidence: device inspection session 2026-10-23 (device-dump/sm-t585/).
