id: todo_t585_investigate_screen_off_idle_baseline_1_7w_2026_10_30
type: todo
area: mainline
perspective: agent
created: 1793317613.463363
edges: [{"target_id": "learning_t585_c2_saves_only_8ma_idle_baseline_1_7w_screen_off_2026_10_30", "edge_type": "derived_from"}]
cue: You work on SM-T585 battery life or idle power, or wonder why the screen-off drain is ~1.7 W.
---

TODO: Investigate the ~1.7 W (~420 mA at ~4.05 V) idle baseline with the screen off. Candidates to bisect: WiFi active mode (power save), panel/DSI supplies still on after blank, always-on regulators left enabled; later cluster power-down (CPD) and SICD. Measure with USB unplugged, per pattern_t585_on_device_measurement_scripts_systemd_run_usb_unplugged_2026_10_30.
