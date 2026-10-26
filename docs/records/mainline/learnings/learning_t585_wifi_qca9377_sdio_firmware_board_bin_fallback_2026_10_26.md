id: learning_t585_wifi_qca9377_sdio_firmware_board_bin_fallback_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1792975511.276162
edges: [{"target_id": "learning_t585_bt_btqca_firmware_names_fallback_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27", "edge_type": "related"}]
cue: ath10k_sdio on the T585 finds no board data or firmware and you must decide which firmware files and packages to ship.
---

Observed: linux-firmware QCA9377 hw1.0 board-2.bin contains only bus=pci entries, so SDIO falls back to board.bin plus firmware-sdio-5.bin (package linux-firmware-ath10k, now in device-samsung-gtaxllte depends, together with wireless-regdb because CFG80211_REQUIRE_SIGNED_REGDB is on). The device's own qcacld bdwlan30.bin (magic bc 1f 66 73) is not an ath10k board container; it is an untested fallback only.
Cause: upstream board-2.bin carries no SDIO board entries for this chip.
Evidence: linux-firmware files and device bdwlan30.bin inspected 2026-10-26; packages linux-samsung-gtaxllte pkgrel 2 and device-samsung-gtaxllte pkgver 4, not yet built with pmbootstrap; nothing tested on HW.
