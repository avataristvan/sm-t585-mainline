id: learning_t585_wlan_enable_pulls_vendor_drivers_pmos_config_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1792975510.82094
edges: [{"target_id": "domain_t585_wifi_mmc1_pwrseq_fixed_regulator_no_ath10k_node_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_pmos_kconfig_overrides_stage1_trims_image_size_2026_10_25", "edge_type": "related"}, {"target_id": "domain_kernel_modules_allowed_where_sensible_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_backlight_class_pulls_defconfig_panel_modules_off_in_pmos_config_2026_10_26", "edge_type": "related"}, {"target_id": "pattern_t585_bt_hciuart_unhides_vendor_hci_drivers_off_in_pmos_config_2026_10_27", "edge_type": "related"}]
cue: You enable WLAN in the T585 kernel config and the build suddenly wants ath11k, wcn36xx or other WLAN vendor drivers.
---

Observed: Enabling WLAN in the T585 kernel config makes arm64 defconfig pull ATH11K, ATH12K and WCN36XX as =m, and every WLAN_VENDOR_* option defaults to y. kernel/gtaxllte-pmos.config therefore lists all non-Atheros vendors plus those three as "is not set".
Cause: defconfig has the WLAN vendor menus default-on once CONFIG_WLAN is set; the board needs only ath10k (SDIO).
Evidence: kernel/gtaxllte-pmos.config (WiFi chunk 1, 2026-10-26); not yet verified on hardware.
