id: learning_t585_gauge_status_from_current_sign_wrong_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793003064.684979
edges: [{"target_id": "domain_t585_sm5703_fuel_gauge_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "related"}]
cue: You see Discharging on the SM-T585 gauge while the charger says Charging, or you touch how the gauge derives battery STATUS.
---

Observed: "Discharging" from sm5703-fuel-gauge on an SDP port (about 450 mA) while the charger says "Charging" is physically possible (net discharge, load above SDP current). Deriving STATUS from the current sign alone is still wrong per the power-supply ABI, also during the 80/75 limiter hold (charging stopped on purpose, supply present).
Cause: the gauge has no link to the charger and uses only the sign of the current.
Fix: implemented and HW-verified, see domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27 and learning_t585_sm5703_fg_status_follows_charger_verified_hw_2026_10_26 (power-supplies = <&charger>, STATUS via the supplier, current sign with deadband as fallback).
Evidence: read-only audit docs/standard-interfaces-audit-2026-10-27.md (code and records only at the time of writing). An earlier version cited a todo id that never existed; the open items live in todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27.
