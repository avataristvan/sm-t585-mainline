id: domain_priority_wifi_dsi_before_nftables_panfrost_bt_2026_10_26
type: domain
area: goal
perspective: user
created: 1792973875.95515
edges: [{"target_id": "domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24", "edge_type": "supersedes"}, {"target_id": "domain_t585_pmos_ui_gnome_mobile_2026_10_26", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_gnome_mobile_power_button_backlight_2026_10_26", "edge_type": "derived_from"}, {"target_id": "domain_t585_wifi_mmc1_pwrseq_fixed_regulator_no_ath10k_node_2026_10_26", "edge_type": "related"}, {"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}]
cue: You choose what to work on next on the SM-T585 after pmOS runs with GNOME Mobile: WiFi, DSI panel, nftables, Panfrost, Bluetooth.
---

Decision: User's order (2026-10-26): real WiFi and the DSI panel first, ahead of nftables, Panfrost mali-supply/OPP and Bluetooth.
Why: The user wants the power button to really turn the display off (GNOME Mobile only blanks to black; simpledrm cannot do DPMS/backlight), and real WiFi.
Scope: Replaces the order of domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24 and the FOCUS NEXT list for these items; the remaining items keep their relative order (nftables, Panfrost OPP, Bluetooth). Current next list: FOCUS.md.
