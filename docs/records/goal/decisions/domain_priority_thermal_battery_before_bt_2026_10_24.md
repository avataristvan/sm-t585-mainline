id: domain_priority_thermal_battery_before_bt_2026_10_24
type: domain
area: goal
perspective: user
created: 1792831297.700486
superseded_by: domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24
valid_until: 1792862250.511733
edges: [{"target_id": "domain_priority_audio_bt_dsi_2026_10_23", "edge_type": "supersedes"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_tmu_exynos7870_mainline_support_2026_10_24", "edge_type": "related"}]
cue: Audio is done on the SM-T585 and you choose the next subsystem: thermal, battery/charging, Bluetooth or the DSI panel.
---

Decision: Priority order on the SM-T585 now (user wish, 2026-10-24): first thermal (Exynos TMU / thermal zones) and battery (SM5703 charger + fuel gauge, no mainline driver), then Bluetooth, then the real DSI panel. Audio is done.
Why: The user stated the order only as a wish, no reason given. Plausibly device safety and usability (heat, charging) before features; that is an inference, not the user's statement.
Scope: Replaces the order in domain_priority_audio_bt_dsi_2026_10_23 (audio -> Bluetooth -> DSI). Open items: todo_sm5703_charger_fuel_gauge_2026_10_23, todo_bluetooth_then_dsi_panel_2026_10_23. The thermal chunk must re-enable THERMAL + EXYNOS_THERMAL in the kernel config deliberately (see domain_kernel_trim_chunk2_builtin_pins_by_reason_2026_10_24).
