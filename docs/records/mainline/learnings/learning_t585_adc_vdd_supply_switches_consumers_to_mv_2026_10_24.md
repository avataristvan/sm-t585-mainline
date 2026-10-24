id: learning_t585_adc_vdd_supply_switches_consumers_to_mv_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792866501.367486
edges: [{"target_id": "domain_t585_adc_vdd_supply_ldo3_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_exynos7870_adc_mainline_support_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_ntc_vs_fg_temp_wall_charger_hw_kernel30_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_check_iio_consumer_values_after_provider_dt_change_2026_10_24", "edge_type": "related"}]
cue: You change the Exynos ADC supply or a NTC lookup table, or read any io-channel of &adc (VBAT, ear-adc, battery NTC) and values look scaled.
---

Observed: Giving the Exynos ADC a real vdd-supply changes what its consumers read. exynos_adc then reports IIO_CHAN_INFO_SCALE = vdd_mV / 4095, so iio_read_channel_processed returns mV instead of raw codes. With the dummy regulator, regulator_get_voltage failed and "processed" fell back to raw. Effect on kernel #31 (first flash with ldo3): the generic-adc-thermal battery NTC table was still in raw codes, so 2017 raw = 886 mV was read as 62.6 C. The charger went to HOT/Overheat and stopped charging (the fail-safe worked).
Cause: The vdd_ldo3 decision switched the unit of every &adc consumer from raw codes to mV; the battery_ntc lookup table was not converted with it. Any other io-channels consumer of &adc (ch3 VBAT, ch2 ear-adc) now sees mV too.
Fix: The lookup table in exynos7870-gtaxllte.dts is converted to mV (raw*1800/4095). It now reads 24.5 C at raw 2023. The ldo3 decision stands; the table had to follow.
Evidence: kernel #31 first flash (boot sha1 2394b2a5fa4e7c686c398e6b65ded5386fde96aa, kernel/out/boot-stage1-k31.img); domain_t585_adc_vdd_supply_ldo3_2026_10_24; domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24.
