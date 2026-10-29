id: domain_t585_standard_linux_interfaces_except_audio_2026_10_27
type: domain
area: goal
perspective: user
created: 1793002346.875791
edges: [{"target_id": "domain_t585_general_lean_tablet_not_music_only_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_camera_not_realistic_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_gauge_status_from_current_sign_wrong_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_hall_pwrkeyd_thermal_checked_fine_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_charge_limit_controlled_by_gnome_upower_default_100_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_no_custom_power_key_console_handling_2026_10_29", "edge_type": "related"}]
cue: You decide whether a T585 peripheral (sensors, camera, Bluetooth) should keep Samsung quirks or follow standard Linux interfaces.
---

Decision: Everything except the audio interfaces may follow standard Linux behaviour; deviations from the vendor way may be smoothed out ("glatt ziehen") so that Linux can handle the device as is. Audio is the exception (own machine driver, own routing). Set by the user on 2026-10-27 when asking to tackle "kamera, sensorik und bluetooth".
Why: The user wants a general lean tablet that ordinary userspace (iio-sensor-proxy, BlueZ, GNOME) handles without vendor shims.
Scope: SM-T585 peripherals other than audio: sensors, Bluetooth, camera. Sensors were done first (2026-10-27, built, untested on HW). Camera stays limited by domain_t585_camera_not_realistic_2026_10_25.
