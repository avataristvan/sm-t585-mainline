id: learning_t585_unused_regulator_cleanup_vdd_fixed_lcd_always_on_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1792976190.709715
edges: [{"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_bootloader_fb_a8r8g8b8_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_boot_on_only_enables_at_registration_cleanup_still_runs_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_sensors_accel_light_mainline_drivers_i2c7_2026_10_27", "edge_type": "related"}]
cue: The panel or another display rail goes dark shortly after boot with simpledrm, though the fixed regulator has regulator-boot-on.
---

Observed: A fixed regulator with regulator-boot-on but no active consumer is switched off by the late unused-regulator cleanup. vdd_fixed_lcd is therefore regulator-always-on, so simpledrm keeps the panel lit while the panel module is not loaded.
Cause: boot-on only keeps the rail until the regulator core's late_initcall cleanup; without a consumer holding it, it is disabled.
Evidence: board DTS exynos7870-gtaxllte.dts (vdd_fixed_lcd); not yet verified on hardware.
