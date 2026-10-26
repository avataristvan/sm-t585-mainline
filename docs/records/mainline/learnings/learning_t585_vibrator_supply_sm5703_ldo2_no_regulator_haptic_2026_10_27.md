id: learning_t585_vibrator_supply_sm5703_ldo2_no_regulator_haptic_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793002347.381378
edges: [{"target_id": "learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24", "edge_type": "related"}]
cue: You want the T585 vibration motor to work and look for its supply regulator or a regulator-haptic node.
---

Observed: The T585 vibrator supply is SM5703 LDO2 ("VDD_MOTOR_3.3", register LDOOUT2CNTL bit 3), not an S2MPU05 LDO. Mainline has no SM5703 regulator driver, and our own sm5703 charger driver owns the device at i2c4@0x49, so a regulator-haptic node cannot be used yet.
Cause: The rail lives in the SM5703 MFD, which only our charger driver binds.
Evidence: downstream DT and driver reading 2026-10-27; see todo_t585_sm5703_ldo2_regulator_for_haptic_2026_10_27 and learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24.
