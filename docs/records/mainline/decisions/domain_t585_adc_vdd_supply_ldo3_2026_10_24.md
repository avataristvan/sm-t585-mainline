id: domain_t585_adc_vdd_supply_ldo3_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792862896.556404
edges: [{"target_id": "learning_t585_exynos7870_adc_mainline_support_2026_10_24", "edge_type": "related"}, {"target_id": "domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_adc_vdd_supply_switches_consumers_to_mv_2026_10_24", "edge_type": "related"}]
cue: You edit the gtaxllte DTS &adc node or wonder what powers the Exynos7870 ADC and why vdd-supply is set.
---

Decision: The Exynos7870 ADC on the SM-T585 gets vdd-supply = vdd_ldo3 (S2MPU05 LDO3, measured 1.8 V, always-on, enabled on the device).
Why: The downstream DT names no ADC supply. The other mainline Exynos boards (exynos5433 TM2, exynos7 Espresso) also power the ADC from ldo3. This is an analogy, not proven from a schematic.
Scope: exynos7870-gtaxllte.dts &adc. Updates the earlier ADC learning learning_t585_exynos7870_adc_mainline_support_2026_10_24, which said "vdd-supply unknown, dummy regulator".
