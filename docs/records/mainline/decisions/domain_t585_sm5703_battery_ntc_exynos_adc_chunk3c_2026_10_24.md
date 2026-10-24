id: domain_t585_sm5703_battery_ntc_exynos_adc_chunk3c_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792859770.271369
edges: [{"target_id": "learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_lineage_charge_reference_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24", "edge_type": "related"}]
cue: You start chunk 3c: reading the SM-T585 battery NTC via Exynos ADC, or need the downstream ADC channel, table and temperature policy.
---

Decision: Next chunk 3c = battery NTC via the Exynos ADC, replacing the FG-temperature proxy (domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24 is to be superseded when 3c lands).
Why: The FG proxy is useless as protection (learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24). Downstream data: battery NTC on exynos_adc channel 1 (io-channels <&exynos_adc 1>; channel 3 = in-bat voltage), ADC at 0x10550000, compatible samsung,exynos-adc-v3 (NOT in mainline exynos_adc.c, which stops at exynos7-adc), irq SPI 395, clock gate_adcif. Lookup table in exynos7870-gtaxllte_eur_open_battery_05.dtsi: temp_table_adc <430 500 581 676 746 838 940 1067 1177 1310 1476 1648 1816 2002 2196 2392 2586 2782 2964 3141 3284 3431 3551> -> temp_table_data <900 850 ... 0 -50 ... -200> (0.1 C, 90 C down to -20 C in 5 C steps); fits mainline generic-adc-thermal (temperature-lookup-table).
Scope: Downstream policy to adopt then: stop < 0 C (recover 5); swelling low 15/20 C and 5/10 C (850 mA, 4.12 V); swelling high > 41 C recover 39 C (1300 mA, 4.12 V float, recharge 3.97 V); stop > 50 C recover 45 C.
