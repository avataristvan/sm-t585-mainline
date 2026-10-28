id: learning_t585_upower_191_charge_limit_udev_property_state_quirk_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793052083.530713
edges: [{"target_id": "domain_t585_charge_limit_gnome_chunk2a_fg_thresholds_forwarded_udev_rule_2026_10_27", "edge_type": "derived_from"}, {"target_id": "learning_t585_simple_battery_monitored_battery_design_props_upower_energy_2026_10_28", "edge_type": "related"}]
cue: upower shows no charge-limit toggle, Discharging while plugged in, or 0 Wh energy for the SM-T585 battery.
---

Observed: upower 1.91 (up-device-supply-battery.c): (a) charge-limit support requires the udev property CHARGE_LIMIT="start,end" on the battery device, otherwise upower ignores the sysfs thresholds; (b) it writes start first, then end, and disabling writes 0 then 100, which is compatible with the charger's start<end validation when the kernel default is 0/100; (c) upower overrides the state to "discharging" whenever current_now < 0 and not full (axp20x quirk), so on a PC port (450 mA, net negative) upower shows discharging although the kernel STATUS is Charging; this is upower policy, the kernel stays as is; (d) without charge_full/energy_full upower shows energy 0 Wh (-> chunk 2b simple-battery).
Cause: upower heuristics and its udev-property gate, not kernel behaviour.
Evidence: upower 1.91.0 source up-device-supply-battery.c; HW session 2026-10-26; domain_t585_charge_limit_gnome_chunk2a_fg_thresholds_forwarded_udev_rule_2026_10_27.
