id: domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792861505.394499
edges: [{"target_id": "learning_t585_exynos7870_adc_mainline_support_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_battery_ntc_exynos_adc_chunk3c_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "supersedes"}]
cue: You touch SM5703 charger temperature protection, battery NTC wiring (generic-adc-thermal, io-channels) or the charge temperature zones.
---

Decision: Battery NTC = generic-adc-thermal node battery_ntc (#io-channel-cells = <0>, added to its binding) on <&adc 1> with the downstream temp_table reversed (ADC values must be descending); thermal zone battery-thermal (5 s polling, informational hot trip 50 C). The SM5703 charger reads it via io-channels "batt-temp" (IIO consumer; module needs MODULE_IMPORT_NS("IIO_CONSUMER") or modpost fails; Kconfig depends on IIO). The FG-temperature emergency stop and the siliconmitus,fuel-gauge phandle are removed. Charger implements the downstream zones with hysteresis: COLD <0 (leave >=5) stop; COOL <15 (leave >=20) 850 mA cap + 4.12 V; NORMAL 4.30 V; WARM >41 (leave <=39) 1300 mA cap + 4.12 V; HOT >50 (leave <=45) stop; NTC read failure = HOT. HEALTH reports COLD/COOL/WARM/OVERHEAT; TEMP prop added (which also makes the power-supply core register a thermal zone "sm5703-charger"). Downstream's software recharge at 3.97 V in swelling is not implemented (chip autostop/recharge only). Supersedes domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24.
Why: Downstream protects only by the ADC NTC; its charger/FG temperature check (chg_temp_check / chg_thermal_source) is not enabled in the gtaxllte DT, and the FG temperature is used only for SOC CURR_CAL compensation (temp_std 25, temp_offset 10). The FG proxy cycled charging and was no protection.
Scope: SM5703 charger driver and board DTS (chunk 3c). Zone logic written by a Sonnet coder from a brief; reviewed by orchestrator. Verified on HW with kernel #30 (learning_t585_ntc_vs_fg_temp_wall_charger_hw_kernel30_2026_10_24); NTC warm-up responsiveness still unproven.
