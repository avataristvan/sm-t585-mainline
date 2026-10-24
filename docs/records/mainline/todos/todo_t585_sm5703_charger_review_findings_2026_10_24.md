id: todo_t585_sm5703_charger_review_findings_2026_10_24
type: todo
area: mainline
perspective: reviewer
created: 1792862244.21048
edges: [{"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_charger_teardown_race_fixed_temp_enodata_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_charger_zones_verified_temp_offset_2026_10_24", "edge_type": "related"}]
cue: You touch sm5703_charger.c again or plan rmmod-heavy charger tests on the SM-T585.
---

TODO: Charger review findings, remaining optional points. Committed in src/mainline (branch gtaxllte) 2f65e1b2d..f7a7eef37: CMU_CPUCL, Exynos7870 TMU, cpufreq-dt boot OPP fix, Exynos7870 ADC, generic-adc-thermal #io-channel-cells, SM5703 fuel gauge + charger, dts. The /simplify review's behavioral points (teardown race, stale TEMP on NTC failure) are FIXED, see learning_t585_sm5703_charger_teardown_race_fixed_temp_enodata_2026_10_24. The cool/warm fast-charge caps (850/1300 mA) are verified with a wall charger (DCP), see learning_t585_sm5703_charger_zones_verified_temp_offset_2026_10_24. Still open, optional: linear_range / regmap_field / monitored-battery refactors; in-bat ADC ch3 (reading unexplained); swelling recharge at 3.97 V.
Evidence: src/mainline ebba667ea.
