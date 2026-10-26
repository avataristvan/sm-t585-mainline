id: learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793043524.142769
edges: [{"target_id": "pattern_t585_twrp_dtb_bisect_swap_in_pmos_boot_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}, {"target_id": "todo_t585_dsi_decisions_after_hw_test_2026_10_26", "edge_type": "related"}, {"target_id": "pattern_t585_panel_power_test_variant_dtb_plus_second_boot_entry_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_dsi_hang_in_first_exynos_drm_atomic_commit_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26", "edge_type": "related"}]
cue: You enable &decon/&dsi in the T585 DTS, or the tablet hangs black right before GDM and only the 2-key PMIC reset helps.
---

Observed: HW-verified 2026-10-27 (pmOS, linux-samsung-gtaxllte r5): enabling &decon and &dsi (exynosdrm built-in plus the panel-samsung-gtaxllte-hx8279d module) hard-hangs the tablet just before GDM. Screen black (pmOS boot logo still showed), only the PMIC 2-key reset (Power+Vol-down) recovers. A DTB with decon and dsi status="disabled" boots to GDM (bisected). decon/dsi are status="disabled" in the DTS source until fixed.
Cause: Not known yet. Suspected: register access with the power domain or clock off.
Evidence: HW test 2026-10-27; DTB bisect via TWRP (pattern_t585_twrp_dtb_bisect_swap_in_pmos_boot_2026_10_27); test plan docs/dsi-test-plan-2026-10-27.md.
