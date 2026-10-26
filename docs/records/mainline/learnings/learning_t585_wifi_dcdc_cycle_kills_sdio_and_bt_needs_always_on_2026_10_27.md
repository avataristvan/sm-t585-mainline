id: learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793043524.376389
edges: [{"target_id": "learning_t585_bt_hci_qca_rome_enable_gpio_clock_vddio_2026_10_27", "edge_type": "confirms"}, {"target_id": "domain_t585_wifi_mmc1_pwrseq_fixed_regulator_no_ath10k_node_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_wifi_qca9377_sdio_firmware_board_bin_fallback_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_wifi_works_5ghz_wps_17mbit_powersave_default_2026_10_27", "edge_type": "related"}]
cue: WiFi on the T585 fails to re-enable the SDIO function or Bluetooth dies ~25 s after boot, and the shared WLAN DCDC is switchable.
---

Observed: HW-verified 2026-10-27: ath10k_sdio probes (qca9377 hw1.1, firmware WLAN.TF.1.1.1-00061 api 5; board-2.bin has no sdio entry, the board.bin fallback works). With cnss_dcdc_en (vdd_fixed_wlan, gpa0-6) as switchable vmmc, ath10k's hif power down/up cycle cut the DCDC: re-enable failed with "unable to enable sdio function: -62", and BT (same DCDC) died about 25 s after boot ("Opcode 0x0c24 failed: -110"). Fix: regulator-always-on on vdd_fixed_wlan (downstream keeps it on too). Then wlan0 scans (nmcli lists APs) and BT stays up. Applied in the DTS source.
Cause: WiFi (mmc1 vmmc) and BT (vddio) share one DCDC; the ath10k SDIO power cycle switches it off under BT.
Evidence: HW test 2026-10-27, r5; learning_t585_bt_hci_qca_rome_enable_gpio_clock_vddio_2026_10_27 (the predicted vddio risk materialised).
