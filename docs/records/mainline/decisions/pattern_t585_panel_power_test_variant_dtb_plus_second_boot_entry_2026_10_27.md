id: pattern_t585_panel_power_test_variant_dtb_plus_second_boot_entry_2026_10_27
type: pattern
area: mainline
perspective: agent
created: 1793001886.779721
edges: [{"target_id": "learning_t585_boot_on_only_enables_at_registration_cleanup_still_runs_2026_10_27", "edge_type": "derived_from"}, {"target_id": "learning_t585_panel_remove_must_disable_unprepare_before_panel_remove_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_pmos_boot_entry_conf_editable_for_one_off_cmdline_2026_10_27", "edge_type": "related"}]
cue: You want to test switching the SM-T585 panel power off and on without risking the default pmOS boot entry.
---

Rule: Test panel power with a variant DTB and a second systemd-boot entry. kernel/tools/mk-panelpwr-dtb.sh runs fdtput -d regulator-always-on on vdd_fixed_lcd and ldo35 in a copy of the built DTB (-> kernel/out/exynos7870-gtaxllte-panelpwr.dtb). Entry pmos-panelpwr.conf is selected through `default` in /boot/loader/loader.conf; the default entry pmos.conf stays untouched. Steps in docs/dsi-test-plan-2026-10-27.md step 2.
When: Testing the panel driver's power on/off (downstream order: iovcc, 10 ms, vdd, 15 ms, reset on; reset, vdd off, 10 ms, iovcc off) where the rails are otherwise always-on.
Why: systemd-boot +N boot counting is not used (no systemd-bless-boot, no keyboard to pick entries), so the fallback is changing `default` back, and the unmodified entry keeps the device bootable. Untested on HW (2026-10-27).
