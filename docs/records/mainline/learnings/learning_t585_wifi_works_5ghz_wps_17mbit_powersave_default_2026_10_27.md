id: learning_t585_wifi_works_5ghz_wps_17mbit_powersave_default_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793044908.669678
edges: [{"target_id": "learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27", "edge_type": "derived_from"}, {"target_id": "domain_t585_wifi_mmc1_pwrseq_fixed_regulator_no_ath10k_node_2026_10_26", "edge_type": "related"}]
cue: You judge or tune SM-T585 WiFi speed or latency, or wonder whether ath10k_sdio works end-to-end after the DCDC fix.
---

Observed: HW-verified 2026-10-27: WiFi works end-to-end on the SM-T585 after the cnss_dcdc_en always-on fix. Connected via WPS to a 5 GHz AP (channel 100), DHCP gave 10.11.12.x, internet OK. Throughput about 17.8 Mbit/s download (wget, 20 MB in 9 s). Gateway ping avg 75 ms, max 197 ms with NetworkManager powersave at its default. Slow but usable. ath10k_sdio runs on mmc1 at 50 MHz, 4-bit, UHS off.
Cause: Likely limits: SDIO clock 50 MHz without UHS (downstream uses sdr104), WiFi powersave on (latency spikes), generic board data. Not yet measured separately.
Evidence: HW test 2026-10-27; learning_t585_wifi_dcdc_cycle_kills_sdio_and_bt_needs_always_on_2026_10_27. Tuning ideas to test: powersave off, SDIO clock/UHS (sdr104), board data.
