id: learning_t585_gauge_status_from_current_sign_wrong_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793003064.684979
edges: [{"target_id": "domain_t585_sm5703_fuel_gauge_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}]
cue: You see Discharging on the SM-T585 gauge while the charger says Charging, or you touch how the gauge derives battery STATUS.
---

Observed: "Discharging" from sm5703-fuel-gauge on an SDP port (about 450 mA) while the charger says "Charging" is physically possible (net discharge, load above SDP current). Deriving STATUS from the current sign alone is still wrong per the power-supply ABI, also during the 80/75 limiter hold (charging stopped on purpose, supply present).
Cause: the gauge has no link to the charger and uses only the sign of the current.
Fix (proposed, untested): set power-supplies = <&charger> on the gauge; the gauge derives STATUS via power_supply_am_i_supplied plus the charger STATUS, with the current sign as fallback behind a deadband.
Evidence: read-only audit docs/standard-interfaces-audit-2026-10-27.md (code and records only, not run on HW). Answers todo_t585_fuel_gauge_status_discharging_vs_charger_charging_2026_10_26.
