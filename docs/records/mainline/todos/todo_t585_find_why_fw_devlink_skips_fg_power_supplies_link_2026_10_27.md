id: todo_t585_find_why_fw_devlink_skips_fg_power_supplies_link_2026_10_27
type: todo
area: mainline
perspective: agent
created: 1793052990.596376
edges: [{"target_id": "learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26", "edge_type": "related"}]
cue: You prepare the SM-T585 fuel gauge for upstreaming or wonder why fw_devlink makes no device link for power-supplies.
---

TODO (low priority, user confirmed): find out why fw_devlink does not create a device link for the fuel gauge's `power-supplies` on gtaxllte although drivers/of/property.c parses it. Relevant for upstreaming: with a working fw_devlink the driver's own device_link_add would be unnecessary. Context: learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26.
