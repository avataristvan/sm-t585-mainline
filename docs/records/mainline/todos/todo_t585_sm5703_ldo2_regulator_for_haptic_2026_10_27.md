id: todo_t585_sm5703_ldo2_regulator_for_haptic_2026_10_27
type: todo
area: mainline
perspective: agent
created: 1793002347.630957
edges: [{"target_id": "learning_t585_vibrator_supply_sm5703_ldo2_no_regulator_haptic_2026_10_27", "edge_type": "derived_from"}]
cue: You pick up the vibrator work on the T585 or change the sm5703 charger driver and need to know that LDO2 export is pending.
---

TODO: Expose SM5703 LDO2 as a regulator from the sm5703 charger driver, then add a regulator-haptic node and INPUT_REGULATOR_HAPTIC=m. Deferred: it changes the working charger driver and needs a HW test. Reason and background: learning_t585_vibrator_supply_sm5703_ldo2_no_regulator_haptic_2026_10_27.
