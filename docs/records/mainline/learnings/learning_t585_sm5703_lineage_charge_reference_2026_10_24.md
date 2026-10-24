id: learning_t585_sm5703_lineage_charge_reference_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792857048.898724
edges: [{"target_id": "learning_t585_sm5703_raw_read_addresses_por_charger_undercharges_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_muic_wall_charger_dev_t3_bit6_2026_10_24", "edge_type": "related"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_fuel_gauge_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_downstream_dt_pins_charger_params_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_battery_ntc_exynos_adc_chunk3c_2026_10_24", "edge_type": "related"}]
cue: You are choosing charger limits, float voltage or temperature source for the SM5703 driver and want the Lineage reference values.
---

Observed: Lineage downstream reference, logged under Lineage with kernel/tools/batt/lineage-battlog.sh. USB SDP: input 450 mA / charge 450 mA. TA (DCP): VBUSCNTL 0x1f = 1650 mA input, CHGCNTL2 0x2e = 2400 mA fast charge, so input-limited; real battery current about +1.0..1.18 A at about 12% SOC. Float voltage CHGCNTL3 = 0x12 = 4.30 V in every case; the POR value 0x16 = 4.34 V must be corrected by the driver. CHGCNTL4 0x11 = 0xd8 while charging, 0x80 with no charger. The normal charger, a Samsung adapter and a QC port behave identically: no fast-charge negotiation (SM5703 has no AFC/QC; 5 V only). Lineage's battery temperature (batt_temp about 26 C) comes from the Exynos ADC thermistor (sec_adc), not from the FG temperature register (FG reads about 36 C). Mainline has no ADC thermistor wiring for it yet, which matters for the charger chunk's temperature limits.
Cause: Downstream sm5703 charger driver sets these per cable type (MUIC) and reads temperature through sec_adc.
Evidence: device-dump/sm-t585-battery-ref/lineage-battlog-2026-10-24.log; learning_t585_sm5703_raw_read_addresses_por_charger_undercharges_2026_10_24.
