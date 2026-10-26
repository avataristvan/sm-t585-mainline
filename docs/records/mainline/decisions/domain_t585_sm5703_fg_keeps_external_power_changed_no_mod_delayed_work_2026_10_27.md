id: domain_t585_sm5703_fg_keeps_external_power_changed_no_mod_delayed_work_2026_10_27
type: domain
area: mainline
perspective: agent
created: 1793053002.926233
edges: [{"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "derived_from"}]
cue: You want to simplify the SM-T585 fuel gauge: drop the duplicate plug uevent or swap external_power_changed for mod_delayed_work.
---

Decision: sm5703_fuel_gauge keeps `.external_power_changed = power_supply_changed`, accepting one duplicate uevent per plug. It also keeps am_i_supplied() before power_supply_get_property_from_supplier(), so an unsupplied gauge reports Discharging without an I2C read.
Why: the 30 s poll's cached state is not updated by the external_power_changed path, so the callback is what makes the change visible at once. Replacing it with mod_delayed_work(poll, 0) would open a use-after-free window: devm cancels the poll work before the psy is unregistered, and an external_power_changed arriving in between would requeue the work.
Scope: src/mainline drivers/power/supply/sm5703_fuel_gauge.c. Review (simplify) of commit 355ad56d0.
