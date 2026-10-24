id: domain_t585_sm5703_fuel_gauge_readonly_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792857713.533546
edges: [{"target_id": "learning_t585_sm5703_lineage_charge_reference_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24", "edge_type": "related"}]
cue: You are tempted to make the SM5703 fuel-gauge driver write init, battery tables or CURR_CAL, or report FG temperature as battery temp.
---

Decision: The SM5703 fuel gauge driver (drivers/power/supply/sm5703_fuel_gauge.c, local driver, CONFIG_BATTERY_SM5703=m, compatible siliconmitus,sm5703-fuel-gauge) is read-only. It never writes the gauge: no init, no battery model tables, no CURR_CAL compensation like downstream does. It only warns when OP_STATUS (0x10) low byte != 0x07.
Why: The gauge keeps its state on the battery and Lineage/TWRP already programmed it. Writing tables/calibration would need the downstream battery data and risks corrupting the SOC.
Scope: The FG chunk. It does not report the FG temperature register as battery temperature, because that is not the battery thermistor (see learning_t585_sm5703_lineage_charge_reference_2026_10_24). STATUS is derived from the current sign until the charger driver exists. Revisit if SOC drifts without downstream's CURR_CAL compensation.
