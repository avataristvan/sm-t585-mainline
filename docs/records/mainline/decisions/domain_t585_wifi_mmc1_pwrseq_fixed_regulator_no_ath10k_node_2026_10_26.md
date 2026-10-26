id: domain_t585_wifi_mmc1_pwrseq_fixed_regulator_no_ath10k_node_2026_10_26
type: domain
area: mainline
perspective: agent
created: 1792975511.047622
edges: [{"target_id": "learning_t585_wifi_qca9377_sdio_firmware_board_bin_fallback_2026_10_26", "edge_type": "related"}, {"target_id": "domain_priority_wifi_dsi_before_nftables_panfrost_bt_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_bt_hci_qca_rome_enable_gpio_clock_vddio_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_wifi_works_5ghz_wps_17mbit_powersave_default_2026_10_27", "edge_type": "related"}]
cue: You are wiring or debugging the T585 WiFi chip on mmc1 in the board DTS (power sequence, host-wake, ath10k node).
---

Decision: T585 WiFi on mmc1 is modelled as mmc-pwrseq-simple (WLAN_EN gpd3-6, active-low reset) plus a fixed regulator cnss_dcdc_en (vdd_fixed_wlan, gpa0-6, 4 ms startup) as vmmc-supply, with regulator-always-on on it. No ath10k child node and no host-wake (gpa2-2). dw-mshc timings copied from j6lte, UHS off.
Why: the qcom,ath10k binding allows interrupts only for ipq4019/wcn3990, and ath10k_sdio probes by SDIO id, so a child node adds nothing and host-wake cannot be described. always-on: the DCDC is shared with BT, and ath10k's power cycle otherwise cut it (HW 2026-10-27, learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27); downstream keeps it on too.
Scope: T585 WiFi DTS (exynos7870-gtaxllte.dts). HW-verified 2026-10-27: wlan0 scans.
