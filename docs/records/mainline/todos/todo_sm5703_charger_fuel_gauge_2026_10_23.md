id: todo_sm5703_charger_fuel_gauge_2026_10_23
type: todo
area: mainline
perspective: user
created: 1792778782.080283
edges: [{"target_id": "learning_mainline_73_exynos7870_gap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_usb_cable_fake_reboots_2026_10_23", "edge_type": "related"}, {"target_id": "learning_i2cx_and_evdecode_tools_2026_10_23", "edge_type": "related"}, {"target_id": "domain_bringup_interactive_devteam_for_drivers_2026_10_23", "edge_type": "related"}]
cue: You want to charge the SM-T585 or read its battery level on stage 1, and no charger or fuel-gauge driver runs there.
---

TODO: SM5703 charger and fuel gauge. The downstream sm5703-fuelgauge (@0x71 on i2c@13830000) is not enabled in our DTS. Step 1: enable that I2C bus in the board DTS and read the gauge voltage raw with kernel/tools/i2cx. Step 2: a proper driver (dev-team candidate). Until then charging is unconfigured and the battery level is unreadable; the user suspects it charges too little or not at all (one PC port supplied less than the tablet draws). Workaround for charging: boot TWRP (Vol-up + Home + Power), which runs the downstream kernel with the charger driver.
