id: learning_t585_held_power_supply_reference_blocks_unregister_warn_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1793052083.04149
edges: [{"target_id": "learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26", "edge_type": "related"}]
cue: You unload or unbind the SM-T585 charger or gauge and power_supply_unregister() warns about use_cnt, or you add power_supply_get_by_name().
---

Observed: power_supply_unregister() WARN_ON(use_cnt) fired when the FG was removed while the charger held a permanent power_supply_get_by_name() reference to it. Fix in sm5703_charger.c: get and put the FG psy per 5 s poll. The FG likewise holds no charger reference (it reads via power_supply_get_property_from_supplier(); writes look up the charger per call). Verified: no WARN in either unload order.
Cause: a held psy reference keeps use_cnt above zero, so the other side cannot unregister cleanly.
Evidence: HW session 2026-10-26; sm5703_charger.c and sm5703_fuel_gauge.c; sibling learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26.
