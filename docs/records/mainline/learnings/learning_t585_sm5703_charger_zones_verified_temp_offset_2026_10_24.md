id: learning_t585_sm5703_charger_zones_verified_temp_offset_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792864119.861078
edges: [{"target_id": "domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24", "edge_type": "confirms"}, {"target_id": "learning_t585_sm5703_charger_teardown_race_fixed_temp_enodata_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_ntc_vs_fg_temp_wall_charger_hw_kernel30_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_sm5703_charger_review_findings_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_t585_charger_test_without_shell_setsid_dcpzones_2026_10_24", "edge_type": "related"}]
cue: You test or change SM5703 charger temperature zones or their current caps (SDP or wall charger) on the SM-T585.
---

Observed: The SM5703 charger temperature zones work on the SM-T585 hardware. Debug module parameter sm5703_charger.temp_offset (unit 0.1 C, mode 0644, runtime-writable at /sys/module/sm5703_charger/parameters/temp_offset) shifts only the temperature the zones see; the reported TEMP stays real.
SDP cable results:
- cool and warm: float drops to 4.12 V, charging continues.
- hot and cold: health Overheat/Cold, status Not charging; the hardware CHGON bit is off, so charging really stops.
- Hysteresis is right: hot stays hot at 47 C and goes to warm at 44 C; cold stays cold at 2 C.
- The cool/warm fast-charge caps (850/1300 mA) could not be seen on SDP, because SDP is already limited to 450 mA.
DCP (wall charger) results, battery about 12 % and 23.7 C, script kernel/out/batt/dcpzones.sh (waits for DCP, logs to /tmp/dcp.log and tty0; the device has no shell while on the charger). Cable type went 0 -> 2 (DCP) and back to 1 (SDP) on the PC:
- normal: ilim 1650, ichg 2400, float 4.30 V; FG current_now about 1027 mA.
- cool: ichg 850, float 4.12 V; FG about 890 mA, so the cap really limits.
- warm: ichg 1300, float 4.12 V; FG about 996 mA. The cap is programmed correctly but does not limit, because the actual charge current (about 1 A) is already below 1300 mA at this battery state.
- After each step the values return to normal.
Cause: temp_offset lets the zone logic be exercised without heating or cooling the battery.
Evidence: test scripts kernel/out/batt/zones.sh and kernel/out/batt/dcpzones.sh; code drivers/power/supply/sm5703_charger.c; zone design in domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24.
