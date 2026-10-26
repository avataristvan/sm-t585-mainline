id: learning_t585_bt_btqca_firmware_names_fallback_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793002790.173249
edges: [{"target_id": "learning_t585_bt_hci_qca_rome_enable_gpio_clock_vddio_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_wifi_qca9377_sdio_firmware_board_bin_fallback_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_bt_qca9377_works_on_hw_firmware_3mbaud_2026_10_27", "edge_type": "related"}]
cue: Bluetooth on the T585 finds no rampatch or nvm file and you must pick which QCA firmware to ship.
---

Observed: btqca requests qca/rampatch_<soc_ver>.bin and qca/nvm_<soc_ver>.bin. linux-firmware has 00130300, 00130302, 00230302 and 00440302. The device files rampatch_tlv_tf_1.1.tlv and nvm_tlv_tf_1.1.bin are the same TLV container (rom_build 0x0302) but differ in content. A usable fallback is DTS firmware-name or copying them under the logged names. Blobs stay out of git.
Cause: the "tf" vendor files have no upstream name; the soc_ver of the real chip is not yet known.
Evidence: docs/bluetooth-test-plan-2026-10-27.md; packages linux-samsung-gtaxllte pkgrel 5, device-samsung-gtaxllte pkgver 5 (adds bluez, linux-firmware-qca); untested on HW. To record after the HW test: the real soc_ver and the firmware used.
