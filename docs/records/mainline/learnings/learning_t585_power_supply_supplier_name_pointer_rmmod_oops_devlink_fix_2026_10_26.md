id: learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1793052082.80545
edges: [{"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_find_why_fw_devlink_skips_fg_power_supplies_link_2026_10_27", "edge_type": "related"}]
cue: You rmmod a power-supply module (charger) while another psy (gauge) lists it in power-supplies, or add a power-supplies link on the SM-T585.
---

Observed: HW 2026-10-26: with the FG's `power-supplies = <&charger>`, `rmmod sm5703_charger` while the FG was bound gave an Oops (FG poll -> power_supply_am_i_supplied -> strcmp on freed module memory) and the tablet hung; the user had to reset it. fw_devlink parses "power-supplies" (drivers/of/property.c) but on this board created NO device link 4-0049 -> 1-0071 (cause not investigated). Fix: the FG probe adds a managed device link itself (device_link_add(dev, charger->dev.parent, DL_FLAG_AUTOREMOVE_CONSUMER) after power_supply_get_by_reference, -EPROBE_DEFER if the charger is not there yet). Verified: rmmod of the charger unbinds the FG first, no oops after more than 30 s. Side effect: after reloading the charger the FG does not rebind by itself (manual `bind` needed); only relevant for module juggling.
Cause: the power-supply core stores the supplier's desc->name POINTER (it lives in the supplier module's rodata) in the supplicant's supplied_from; without a device link the supplicant outlives the supplier's memory.
Evidence: HW session 2026-10-26; sm5703_fuel_gauge.c probe; domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27.
