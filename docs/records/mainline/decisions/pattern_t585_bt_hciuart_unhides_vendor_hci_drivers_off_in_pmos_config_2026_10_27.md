id: pattern_t585_bt_hciuart_unhides_vendor_hci_drivers_off_in_pmos_config_2026_10_27
type: pattern
area: mainline
perspective: agent
created: 1793002790.401803
edges: [{"target_id": "learning_t585_wlan_enable_pulls_vendor_drivers_pmos_config_2026_10_26", "edge_type": "confirms"}, {"target_id": "learning_t585_backlight_class_pulls_defconfig_panel_modules_off_in_pmos_config_2026_10_26", "edge_type": "confirms"}]
cue: You enable a new subsystem such as BT_HCIUART in the T585 config and defconfig vendor drivers silently reappear.
---

Rule: When enabling a subsystem in the T585 kernel config, expect the arm64 defconfig vendor drivers hidden behind it to turn on, and switch them off explicitly in kernel/gtaxllte-pmos.config. For Bluetooth: BT core and profiles as modules (BT, RFCOMM, BNEP, HIDP, HCIUART, QCA); serdev plus the QCA protocol built into hci_uart.
When: Before or right after adding BT_HCIUART, WLAN, BACKLIGHT_CLASS_DEVICE or any similar menu gate; check the merged .config for new =m options.
Why: Third occurrence, after WLAN and BACKLIGHT_CLASS_DEVICE: BT_HCIUART unhides defconfig vendor HCI drivers, and the image budget and module list suffer silently.
