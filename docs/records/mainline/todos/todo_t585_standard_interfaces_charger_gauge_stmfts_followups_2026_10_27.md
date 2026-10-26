id: todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27
type: todo
area: mainline
perspective: agent
created: 1793003064.935437
edges: [{"target_id": "learning_t585_gauge_status_from_current_sign_wrong_2026_10_27", "edge_type": "derived_from"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}]
cue: You are making SM-T585 battery, charger, touch or key handling standard for upower/GNOME and pmOS, and need the ranked open items.
---

TODO (ranked, all need HW; from docs/standard-interfaces-audit-2026-10-27.md, untested):
1. Battery supply (gauge) is where upower/GNOME read: move or forward charge_control thresholds, temp and health there. The 80/75 boot default is a user policy: ask the user before changing it.
2. Add simple-battery + monitored-battery; use power_supply_changed()/external_power_changed instead of 5 s polling; check the TOPOFF -> Full mapping on HW. STATUS fix: see learning_t585_gauge_status_from_current_sign_wrong_2026_10_27.
3. Remove temp_offset (0644 module parameter can defeat the overheat cut-off) or move it to debugfs.
4. stmfts: devm_pm_runtime_enable() before input_register_device (root cause of "error -13", upstream bug).
5. Home key is KEY_HOMEPAGE: remap via hwdb in the device package.
6. charger/gauge as =m leave the 4.34 V POR float until load: build in, or load from the initramfs.
7. deviceinfo has a stray initcall_blacklist= line without prefix (ignored): remove.
Deferred: MUIC extcon / OTG.
