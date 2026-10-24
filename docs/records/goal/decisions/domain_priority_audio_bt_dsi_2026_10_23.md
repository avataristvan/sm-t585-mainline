id: domain_priority_audio_bt_dsi_2026_10_23
type: domain
area: goal
perspective: user
created: 1792769208.077887
superseded_by: domain_priority_thermal_battery_before_bt_2026_10_24
valid_until: 1792831297.91234
edges: [{"target_id": "learning_mainline_73_exynos7870_gap_2026_10_23", "edge_type": "derived_from"}, {"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "todo_audio_analysis_lpass_i2s_2026_10_23", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_lpass_is_not_exynos5433_lpass_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_codec_probes_mainline_2026_10_23", "edge_type": "related"}]
cue: Touch works on the SM-T585 and you must pick the next subsystem: audio, Bluetooth or the real DSI panel.
---

Decision: Priority order after touch: internal audio (LPASS + I2S + RT5659) first, then Bluetooth, then the real DSI panel driver.
Why: The user has no BT headphones; telnet over USB is enough for access meanwhile. Mainline already has exynos-lpass (drivers/mfd/exynos-lpass.c) and the samsung i2s (exynos7-i2s) from Exynos5433, and downstream uses lpass-exynos7870.c + i2s-v5, so 7870 audio is likely an adaptation rather than a new driver (to be verified). Bluetooth stays valuable later: it would let the user's ExoDeck app (~/workspace/ExoDeck-project/ExoDeck, Android BT HID device) act as a controller, and gives A2DP audio (too much latency for live play). BT firmware rampatch_tlv_tf_1.1.tlv / nvm_tlv_tf_1.1.bin is in the dump; whether mainline hci_qca accepts the "tf" variant is open.
Scope: galaxy-tab-a-10.
