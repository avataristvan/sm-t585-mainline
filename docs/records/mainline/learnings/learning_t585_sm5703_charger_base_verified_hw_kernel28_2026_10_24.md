id: learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792858886.16772
edges: [{"target_id": "learning_t585_sm5703_lineage_charge_reference_2026_10_24", "edge_type": "confirms"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charger_cable_detect_muic_readonly_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_vibrator_supply_sm5703_ldo2_no_regulator_haptic_2026_10_27", "edge_type": "related"}]
cue: You are checking whether the SM5703 charger driver really charges the SM-T585 on stage 1, or what input current each cable type gets.
---

Observed: The SM5703 charger driver (drivers/power/supply/sm5703_charger.c, CONFIG_CHARGER_SM5703=m, loaded at boot from the initramfs after the fuel gauge) works on HW, kernel #28, BOOT sha1 206ce1e3cef2c68c9522f5b61103c36114331267. DT: muic: extcon@25 on i2c2 with no driver bound; charger@49 on i2c4 with enable-gpios gpd1-3 active low and phandles siliconmitus,muic / siliconmitus,fuel-gauge; EXTCON_SM5502 is pinned off in gtaxllte-stage1.config. On a PC port registers 0x0c-0x13 read 55 07 03 07 12 d8 7a 08, byte-identical to Lineage's SDP state (4.30 V, autostop, topoff 375 mA, 450/450 mA); battery -210 mA at 12% SOC (input-limited, expected). On the wall charger the 5 s poll switched to DCP within one poll: 1650/2400 mA, battery +900 mA at 12% SOC. Unplug/replug passes through cable type UNKNOWN (VBUS lost), which falls back to 450/450. Battery alone draws about -780 mA.
Cause: The driver applies the Lineage per-cable values (float 4.30 V, 450 mA SDP, 1650 mA input on DCP) polled every 5 s; cable type comes from the MUIC read-only path.
Evidence: battlog on stage 1 (/tmp/batt.log), dmesg "cable type 1/0/2/0/1"; reference values in learning_t585_sm5703_lineage_charge_reference_2026_10_24.
