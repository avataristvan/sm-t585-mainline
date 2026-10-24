id: learning_t585_sm5703_fg_temp_follows_charger_heat_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792858886.383359
superseded_by: learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24
valid_until: 1792859770.503605
edges: [{"target_id": "learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "related"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}]
cue: You are relying on the SM5703 fuel-gauge temperature as battery temperature, or the 55 C charge stop trips during normal wall charging.
---

Observed: The SM5703 fuel-gauge temperature register follows the charger's heat, not the battery: on the wall charger at about 900 mA it rose 31 -> 47 C within 40 s and fell back to 35.7 C within 10 s of unplugging. A battery cannot change that fast.
Cause: The FG sensor sits next to the charger and picks up its dissipation, so it is a poor battery proxy. The 55 C emergency stop (domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24) may therefore trip during normal DCP charging. Open: whether it plateaus below 55 C over a longer charge.
Evidence: battlog 2026-10-24, kernel #28 (see learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24).
