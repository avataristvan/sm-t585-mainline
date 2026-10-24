id: domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792858049.650084
superseded_by: domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24
valid_until: 1792861512.227216
edges: [{"target_id": "learning_t585_sm5703_downstream_dt_pins_charger_params_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_lineage_charge_reference_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_fuel_gauge_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_fg_temp_follows_charger_heat_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_battery_ntc_exynos_adc_chunk3c_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24", "edge_type": "related"}]
cue: You are wondering where the SM5703 charger gets a battery temperature limit from before the ADC thermistor is wired, or why FG temp is used.
---

Decision: Until the Exynos ADC battery thermistor is wired in mainline, the charger driver uses the SM5703 fuel-gauge temperature register as an emergency stop only: charging stops at about 55 C FG temperature, resumes below 50 C. The FG reads about 10 C above the real thermistor (single comparison 36 vs 26 C, not calibrated).
Why: No battery NTC in mainline yet; downstream limits are 0..50 C (recovery 45 C) on the ADC thermistor (exynos7870-gtaxllte_eur_open_battery_05.dtsi temp_high_threshold_normal 500 / recovery 450, low 0 / 50). A conservative proxy beats no limit; the real ADC thermistor is a later separate chunk.
Scope: Charger chunk (battery chunk 3); superseded once the ADC thermistor chunk lands. The FG driver itself still does not report this as battery temperature (domain_t585_sm5703_fuel_gauge_readonly_2026_10_24).
