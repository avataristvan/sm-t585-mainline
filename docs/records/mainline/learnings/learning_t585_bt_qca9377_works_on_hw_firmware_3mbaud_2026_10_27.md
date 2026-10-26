id: learning_t585_bt_qca9377_works_on_hw_firmware_3mbaud_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793043524.614879
edges: [{"target_id": "learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_bt_hci_qca_rome_enable_gpio_clock_vddio_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_bt_btqca_firmware_names_fallback_2026_10_27", "edge_type": "related"}]
cue: You bring up or debug Bluetooth on the T585 (hci_qca, serial1) and wonder which firmware, baud rate and clock work.
---

Observed: HW-verified 2026-10-27: BT QCA9377 on serial1 via hci_qca works. SOC 0x00000023, ROM 0x0302, controller version 0x00230302. linux-firmware qca/rampatch_00230302.bin and qca/nvm_00230302.bin load fine; the device tf_1.1 files are not needed. 3 Mbaud works. The fixed-clock 32 kHz stand-in is sufficient. bluetoothctl scan finds devices. One harmless "Frame reassembly failed (-84)" at setup. Needs the WLAN DCDC always on (see the WiFi learning).
Cause: The real soc_ver is 00230302, which linux-firmware ships; so no renamed vendor blobs are needed.
Evidence: HW test 2026-10-27; plan docs/bluetooth-test-plan-2026-10-27.md.
