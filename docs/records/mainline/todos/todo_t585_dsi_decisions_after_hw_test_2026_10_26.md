id: todo_t585_dsi_decisions_after_hw_test_2026_10_26
type: todo
area: mainline
perspective: agent
created: 1792976190.924683
edges: [{"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "derived_from"}, {"target_id": "learning_t585_unused_regulator_cleanup_vdd_fixed_lcd_always_on_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_gnome_mobile_power_button_backlight_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_dsi_hang_in_first_exynos_drm_atomic_commit_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}]
cue: The DSI panel hardware test on the SM-T585 is done and you ask what to settle next.
---

TODO: The first DSI HW test (2026-10-27) hard-hung the tablet before GDM, so first find the hang's root cause (suspected register access with power domain or clock off; decon/dsi are status="disabled" until then, see learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27). Then, with the panel working (docs/dsi-test-plan-2026-10-27.md), decide: (1) whether to drop simple-framebuffer; (2) whether to make the panel supplies switchable (blanking currently does only DSI sleep + reset, no power cut; today vdd_fixed_lcd is always-on); (3) which DRM card mutter uses (simpledrm card0 vs exynos card1).
