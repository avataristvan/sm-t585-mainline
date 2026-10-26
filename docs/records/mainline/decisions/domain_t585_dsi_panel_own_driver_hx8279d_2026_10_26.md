id: domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26
type: domain
area: mainline
perspective: agent
created: 1792976189.833338
edges: [{"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}, {"target_id": "domain_priority_wifi_dsi_before_nftables_panfrost_bt_2026_10_26", "edge_type": "related"}, {"target_id": "pattern_t585_panel_power_test_variant_dtb_plus_second_boot_entry_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_panel_remove_must_disable_unprepare_before_panel_remove_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}]
cue: You are about to add or change the SM-T585 DSI panel driver and wonder whether to extend panel-himax-hx8279.
---

Decision: The HX8279D panel of the gtaxllte gets its own driver drivers/gpu/drm/panel/panel-samsung-gtaxllte-hx8279d.c (compatible samsung,gtaxllte-boe-hx8279d, built =m), not a variant of panel-himax-hx8279.
Why: Downstream uses a raw 257-write vendor init table with undocumented registers, sleep/display on via vendor registers B2/B3 instead of DCS, and brightness via a DSI register. The mainline hx8279 desc model (documented GOA/gamma fields, backlight phandle, DCS sleep) does not fit, and changing it would affect other panels. The true panel vendor is unknown, so the compatible is board-based.
Scope: gtaxllte panel only. HW test 2026-10-27: enabling &decon/&dsi with this driver hard-hangs the tablet before GDM (see learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27); decon/dsi are status="disabled" in the DTS until fixed. Test plan docs/dsi-test-plan-2026-10-27.md.
