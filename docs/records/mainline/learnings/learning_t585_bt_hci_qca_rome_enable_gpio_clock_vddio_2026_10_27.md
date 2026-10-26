id: learning_t585_bt_hci_qca_rome_enable_gpio_clock_vddio_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793002789.945118
edges: [{"target_id": "learning_t585_bt_uart_serial1_hci_qca_wiring_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_wifi_mmc1_pwrseq_fixed_regulator_no_ath10k_node_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_bt_qca9377_works_on_hw_firmware_3mbaud_2026_10_27", "edge_type": "related"}]
cue: You model the QCA9377 Bluetooth node in the T585 DTS and wonder which supplies, clock and wake GPIOs hci_qca actually uses.
---

Observed: The hci_qca ROME path (qcom,qca9377-bt / qca6174-bt, no match data) only uses enable-gpios (BT_EN gpd4-0) plus an optional 32 kHz clock, and ignores supply properties. The binding nonetheless requires clocks, and mainline S2MPU05 exposes no 32 kHz output, so a fixed-clock stand-in bt_sleep_clk (32768 Hz) is used (an assumption). BT_WAKE gpa1-2 and BT_HOST_WAKE gpa1-6 are not wired (no binding support; in-band sleep). Init speed 115200, operating speed 3 Mbaud by default (fallback: max-speed). vddio-supply = vdd_fixed_wlan (cnss_dcdc_en), shared with WiFi and only held on by the mmc1 vmmc. Risk: if mmc powers it off, BT loses power.
Cause: hci_qca ROME handling is minimal; the shared WLAN rail is owned by the mmc1 power sequence.
Evidence: board DTS and hci_qca/binding review, 2026-10-27; untested on HW. To record after the HW test: whether 3 Mbaud works, the real 32 kHz clock source.
