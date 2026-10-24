id: domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792859785.932253
edges: [{"target_id": "domain_t585_sm5703_fuel_gauge_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24", "edge_type": "related"}]
cue: You want to change, disable or debug the SM5703 80/75 percent charge limit, or charge_control_end_threshold returns EINVAL.
---

Decision: The SM5703 charge limiter in sm5703_charger.c is software-only. The 5 s poll reads CAPACITY from the "sm5703-fuel-gauge" power supply and drives nCHG_EN (gpd1-3) off when capacity >= end, back on when <= start. Standard sysfs props charge_control_end_threshold / charge_control_start_threshold are writable and switchable at runtime (end=100 disables). Boot default via module params charge_end=80 / charge_start=75 (mode 0444). Start must stay strictly below end, so writes are order-dependent: lowering end below start returns EINVAL (lower start first). STATUS reports "Not charging" while limited.
Why: The SM5703 has no percentage-based charge end; the user wants battery longevity on a mostly-plugged-in music device. SOC comes from the read-only FG without CURR_CAL, so the 80 % can be off by a few percent.
Scope: Charger chunk 3b (done); verified in learning_t585_sm5703_chunk3b_limiter_verified_module_swap_2026_10_24.
