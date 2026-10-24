id: learning_t585_ntc_vs_fg_temp_wall_charger_hw_kernel30_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792861505.634999
edges: [{"target_id": "domain_t585_sm5703_battery_ntc_generic_adc_thermal_charger_zones_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24", "edge_type": "related"}]
cue: You compare battery NTC and fuel-gauge temperature on the wall charger, or wonder if NTC protection really responds.
---

Observed: Verified on HW, kernel #30. NTC reads 24.0 C at room temp. On the wall charger for 8.5 min at a steady +1035 mA (no on/off cycling any more), NTC rose only 24.0 -> 24.2 C while the FG temperature climbed to 59 C and flattened; SoC 32-33 C; SOC 12 -> 14 %. Warm-up check (same kernel, charger unplugged, PC port): a hand on the back over the battery raised the NTC 24.2 -> 25.2 C within about 40 s, still rising, while the FG temperature kept falling (38 C, charger-path heat decaying). So the NTC (battery-thermal zone, ADC ch1) does respond to real battery heat and is independent of the FG reading.
Cause: FG temperature follows charger heat, not the battery. The display runs at full brightness on stage 1 (S-Boot setting, no backlight control without a DSI panel driver), which adds heat; the earlier Lineage FG reading (about 36 C) is therefore not comparable.
Evidence: tool kernel/out/batt/ntclog.sh (NTC vs FG temp, charger state, every 10 s, /tmp/ntc.log + tty0); learning_t585_sm5703_fg_temp_cycles_charge_useless_protection_2026_10_24.
