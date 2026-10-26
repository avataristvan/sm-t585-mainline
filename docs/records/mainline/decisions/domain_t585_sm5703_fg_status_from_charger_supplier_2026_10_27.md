id: domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27
type: domain
area: mainline
perspective: agent
created: 1793051249.232842
edges: [{"target_id": "learning_t585_gauge_status_from_current_sign_wrong_2026_10_27", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_fuel_gauge_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_charge_limit_controlled_by_gnome_upower_default_100_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_fg_keeps_external_power_changed_no_mod_delayed_work_2026_10_27", "edge_type": "related"}]
cue: You touch how the SM-T585 fuel gauge derives battery STATUS, or see Discharging/Charging disagree between gauge and charger.
---

Decision: The SM5703 fuel-gauge battery STATUS derives from its supplier (the charger), not from the sign of the current.
Implementation: power_supply_am_i_supplied() == 0 -> Discharging; > 0 -> the supplier's STATUS via power_supply_get_property_from_supplier(); if that fails, the current sign with a 20 mA deadband (supplied -> Not charging). The gauge sets .external_power_changed = power_supply_changed; a 30 s delayed work (devm_delayed_work_autocancel) calls power_supply_changed on capacity/status change.
Why: power-supply ABI and upower semantics. Net current is negative on an SDP port (450 mA limit) and during the 80/75 limiter hold although charging is in progress or deliberately paused with supply present.
Scope: src/mainline drivers/power/supply/sm5703_fuel_gauge.c and exynos7870-gtaxllte.dts (`charger:` label, gauge `power-supplies = <&charger>`). Consequence: gauge registration defers until the charger psy is registered (no battery at all if the charger fails to probe). Closes audit chunk 1 (#1, #4 gauge part) of todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27.
Evidence: src/mainline fork branch gtaxllte (not pushed): c0730b219 charger, 355ad56d0 fuel gauge, c766e6fff DTS; main 20ed24a (pmos + submodule bump).
