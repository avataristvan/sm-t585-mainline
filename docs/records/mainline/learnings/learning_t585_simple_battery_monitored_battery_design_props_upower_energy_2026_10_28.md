id: learning_t585_simple_battery_monitored_battery_design_props_upower_energy_2026_10_28
type: learning
area: mainline
perspective: agent
created: 1793226617.227499
edges: [{"target_id": "learning_t585_upower_191_charge_limit_udev_property_state_quirk_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27", "edge_type": "related"}]
cue: You add or debug SM-T585 battery capacity or voltage data and upower shows 0 Wh, wrong Wh, or missing design values.
---

Observed: Chunk 2b is done and HW-verified. A simple-battery node (from downstream exynos7870-gtaxllte_eur_open_battery_05.dtsi: 7300 mAh, voltage-min 3.40 V from tem_poff, voltage-max 4.35 V cell, constant-charge 4.30 V, termination 375 mA) plus monitored-battery on the fuel gauge. power_supply_register() reads the battery info for a BATTERY-type psy and exposes CHARGE_FULL_DESIGN, VOLTAGE_MIN/MAX_DESIGN and the other design properties itself, so the FG driver adds only CHARGE_FULL (= design; the gauge's learned capacity is not read) and CHARGE_NOW (SOC with its 1/256 fraction x full). upower 1.91 converts charge to energy using voltage_max_design first (31.8 Wh shown).
Cause: Core power_supply code owns the design properties once monitored-battery is set; upower needs charge_full (or energy_full) to show non-zero Wh.
Evidence: src/mainline commits 84bab23d2, a7fce9098; main commit 39d005e; learning_t585_upower_191_charge_limit_udev_property_state_quirk_2026_10_27 (point d, the 0 Wh problem this fixes).
