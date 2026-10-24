id: learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792859770.058213
edges: [{"target_id": "learning_t585_sm5703_fg_temp_follows_charger_heat_2026_10_24", "edge_type": "supersedes"}, {"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_ntc_vs_fg_temp_wall_charger_hw_kernel30_2026_10_24", "edge_type": "related"}]
cue: You judge whether the SM5703 FG-temperature 55/50 C stop protects the battery, or charging on the wall charger starts/stops every 20-30 s.
---

Observed: On the wall charger at about 1030 mA the FG temperature reaches 55 C in about 2 min, the 55/50 C FG emergency stop trips, the FG temperature drops to about 41 C within 5-10 s and charging resumes. It cycles every 20-30 s (average maybe 600 mA) while the SoC TMU stays 32-33 C.
Cause: The FG sensor follows charger heat, not the battery (earlier finding); this closes its open plateau question: no plateau, a limit cycle.
Evidence: learning_t585_sm5703_fg_temp_follows_charger_heat_2026_10_24. Consequence: the FG proxy is safe but useless as battery protection; keep it only until the ADC thermistor lands (chunk 3c).
