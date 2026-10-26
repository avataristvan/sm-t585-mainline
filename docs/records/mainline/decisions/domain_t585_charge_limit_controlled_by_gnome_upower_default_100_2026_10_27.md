id: domain_t585_charge_limit_controlled_by_gnome_upower_default_100_2026_10_27
type: domain
area: mainline
perspective: user
created: 1793051334.537036
edges: [{"target_id": "domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24", "edge_type": "supersedes"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "derived_from"}, {"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_charge_limit_gnome_chunk2a_fg_thresholds_forwarded_udev_rule_2026_10_27", "edge_type": "related"}]
cue: You change the SM5703 charge limit default, or wonder who sets the battery charge limit on the SM-T585 (GNOME Battery Health Charging).
---

Decision (user, 2026-10-26): The charge limit is controlled by GNOME/upower ("Battery Health Charging"), not by a kernel default. The kernel default becomes 100 % (no limit). The thresholds are exposed on the battery (fuel-gauge) supply as charge_control_start_threshold / charge_control_end_threshold and forwarded to the charger. The limiter mechanism itself (software limiter in sm5703_charger.c, order-dependent start < end writes) stays as described in domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24.
Why: the user wants the standard mechanism ("gnome sollte es kontrollieren, wenn es einen standard dafuer gibt, dann gern umsetzen"); follows domain_t585_standard_linux_interfaces_except_audio_2026_10_27. Upower/GNOME read and write the battery supply, which is the gauge.
Scope: sm5703_charger.c module param defaults (charge_end 80 -> 100, charge_start accordingly) and sm5703_fuel_gauge.c (threshold properties + forwarding). Work split: chunk 2a = this; chunk 2b = simple-battery props. Supersedes only the 80/75-by-default part of the old decision.
