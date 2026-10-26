id: learning_t585_backlight_class_pulls_defconfig_panel_modules_off_in_pmos_config_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1792976190.496633
edges: [{"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_wlan_enable_pulls_vendor_drivers_pmos_config_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_pmos_kconfig_overrides_stage1_trims_image_size_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_bt_hciuart_unhides_vendor_hci_drivers_off_in_pmos_config_2026_10_27", "edge_type": "related"}]
cue: You enable BACKLIGHT_CLASS_DEVICE in the T585 config and the build suddenly offers dozens of panel and backlight modules.
---

Observed: Enabling BACKLIGHT_CLASS_DEVICE in the T585 config exposes about 28-30 arm64 defconfig panel and backlight modules. They are switched off explicitly in kernel/gtaxllte-pmos.config.
Cause: defconfig sets those panel/backlight options that depend on the backlight class; once it is on they become =m. Same pattern as the WLAN vendor options.
Evidence: kernel/gtaxllte-pmos.config (DSI chunk, 2026-10-26); learning_t585_wlan_enable_pulls_vendor_drivers_pmos_config_2026_10_26.
