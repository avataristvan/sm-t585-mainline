id: domain_t585_charge_limit_gnome_chunk2a_fg_thresholds_forwarded_udev_rule_2026_10_27
type: domain
area: mainline
perspective: agent
created: 1793052083.28824
edges: [{"target_id": "learning_t585_upower_191_charge_limit_udev_property_state_quirk_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_charge_limit_controlled_by_gnome_upower_default_100_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_standard_interfaces_charger_gauge_stmfts_followups_2026_10_27", "edge_type": "related"}]
cue: You wonder how the SM-T585 charge limit reaches upower/GNOME, or edit the CHARGE_LIMIT udev rule or the charger threshold defaults.
---

Decision: Chunk 2a is implemented and HW-verified. The fuel gauge exposes HEALTH, TEMP and CHARGE_CONTROL_{START,END}_THRESHOLD (thresholds writable) and forwards the thresholds to the charger. The charger module param defaults are now 100/0 (no limit). The device package pmos/device-samsung-gtaxllte (pkgrel 3) ships 61-gtaxllte-battery.rules, setting udev ENV{CHARGE_LIMIT}="75,80" on KERNEL=="sm5703-fuel-gauge", so upower offers the toggle.
Why: refines domain_t585_charge_limit_controlled_by_gnome_upower_default_100_2026_10_27 (GNOME controls the limit, the kernel default is no limit). Verified with upower 1.91.0: charge-threshold-supported yes; EnableChargeThreshold true -> 75/80 on gauge and charger, false -> 0/100; forced 60/70 at 74 % -> "charging paused", status Not charging; off -> resumed. The GNOME UI toggle itself is not yet tried (gdm disabled).
Scope: sm5703_fuel_gauge.c, sm5703_charger.c, pmos/device-samsung-gtaxllte. Open: chunk 2b (simple-battery props).
Evidence: src/mainline fork branch gtaxllte (not pushed): c0730b219 charger, 355ad56d0 fuel gauge, c766e6fff DTS; main 20ed24a (pmos + submodule bump). Installed as packages linux-samsung-gtaxllte 7.3.0_p20261026230414 (pkgrel 7) and device-samsung-gtaxllte 5-r3, verified after reboot.
