id: todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27
type: todo
area: mainline
perspective: agent
created: 1793003064.935437
edges: [{"target_id": "learning_t585_gauge_status_from_current_sign_wrong_2026_10_27", "edge_type": "derived_from"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_charge_limit_controlled_by_gnome_upower_default_100_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_charge_limit_gnome_chunk2a_fg_thresholds_forwarded_udev_rule_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_power_supply_supplier_name_pointer_rmmod_oops_devlink_fix_2026_10_26", "edge_type": "related"}]
cue: You are making SM-T585 battery, charger, touch or key handling standard for upower/GNOME and pmOS, and need the ranked open items.
---

TODO (ranked, all need HW; numbers follow docs/standard-interfaces-audit-2026-10-27.md):
DONE chunk 1 (2026-10-26, HW-verified): gauge power-supplies link, charger-aware STATUS, external_power_changed (audit #1, #4 gauge part): domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27. Still open of #4: MUIC-IRQ part (charger cached `online`, ~4 s lag after unplug).
DONE chunk 2a (2026-10-26, HW-verified): thresholds, TEMP and HEALTH on the gauge, forwarded to the charger; kernel default 100/0; the user decided GNOME controls the limit, 75/80 only via udev CHARGE_LIMIT in the device package: domain_t585_charge_limit_gnome_chunk2a_fg_thresholds_forwarded_udev_rule_2026_10_27 (old item 1 and the "#6 default" question are settled). Only the GNOME UI toggle is still untried (gdm disabled).
Open (user's list, audit numbering): 2b simple-battery + monitored-battery (check the TOPOFF -> Full mapping on HW; upower shows 0 Wh without charge_full/energy_full, see learning_t585_upower_191_charge_limit_udev_property_state_quirk_2026_10_27; charger polling 5 s vs interrupts), #5, #7, #10, the MUIC-IRQ part of #4, #8 stmfts, #12, #13.
Earlier notes, still true where not marked done: remove temp_offset (0644 module parameter can defeat the overheat cut-off) or move it to debugfs; stmfts needs devm_pm_runtime_enable() before input_register_device (root cause of "error -13", upstream bug); Home key is KEY_HOMEPAGE, remapped via hwdb in the device package (done in 5-r2); charger/gauge as =m leave the 4.34 V POR float until load (build in or load from the initramfs); deviceinfo has a stray initcall_blacklist= line without prefix (ignored): remove.
Deferred: MUIC extcon / OTG.
