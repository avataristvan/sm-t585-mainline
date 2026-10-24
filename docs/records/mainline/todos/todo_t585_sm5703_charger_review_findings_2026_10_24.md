id: todo_t585_sm5703_charger_review_findings_2026_10_24
type: todo
area: mainline
perspective: reviewer
created: 1792862244.21048
edges: [{"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}]
cue: You touch sm5703_charger.c again or plan rmmod-heavy charger tests on the SM-T585.
---

TODO: Charger review findings. Committed in src/mainline (branch gtaxllte) 2f65e1b2d..f7a7eef37: CMU_CPUCL, Exynos7870 TMU, cpufreq-dt boot OPP fix, Exynos7870 ADC, generic-adc-thermal #io-channel-cells, SM5703 fuel gauge + charger, dts. Committed code = kernel #30 plus behavior-preserving review cleanups only (not re-flashed). The /simplify review (reuse/quality/efficiency) left behavioral points open: (1) teardown race in sm5703_charger: a sysfs threshold write between work autocancel and psy unregister can requeue the poll; (2) TEMP reports a stale value when the NTC read fails. Optional: linear_range / regmap_field / monitored-battery refactors; in-bat ADC ch3 (reading unexplained); swelling recharge at 3.97 V.
Evidence: src/mainline ebba667ea.
