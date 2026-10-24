id: domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24
type: domain
area: goal
perspective: user
created: 1792862244.422471
edges: [{"target_id": "domain_priority_thermal_battery_before_bt_2026_10_24", "edge_type": "supersedes"}, {"target_id": "todo_t585_sm5703_charger_review_findings_2026_10_24", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_adc_vdd_supply_ldo3_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_pmic_reset_test_numbered_images_flash_panfrost_2026_10_24", "edge_type": "related"}]
cue: Battery chunk 3 is done on the SM-T585 and you choose what to work on next.
---

Decision: User's order (2026-10-24): 1 fix the dtbs_check warnings (adc vdd-supply, rt5659 interrupts, s1402x/sound/dispaud-reset schemas, i2s resets) + ADC dummy regulator; 2 charger review findings; 3 test COOL/WARM/HOT zones on HW; 4 power button with standard behaviour (short press = display off, long press = power off, like logind/Android); 5 Panfrost (Mali-T830); 6 Bluetooth. Then evaluate whether our mainline kernel can run the installed LineageOS userspace, otherwise postmarketOS.
Why: not stated by the user.
Scope: Replaces domain_priority_thermal_battery_before_bt_2026_10_24 (thermal and battery are done). The DSI panel is not in the new list. State: FOCUS.md and docs/handoff-2026-10-24.md carry the current next list.
