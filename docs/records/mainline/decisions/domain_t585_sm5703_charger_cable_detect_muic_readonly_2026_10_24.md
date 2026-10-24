id: domain_t585_sm5703_charger_cable_detect_muic_readonly_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792858049.439433
edges: [{"target_id": "domain_t585_sm5703_charger_temp_limit_fg_proxy_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_downstream_dt_pins_charger_params_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_sm5703_muic_wall_charger_dev_t3_bit6_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24", "edge_type": "related"}]
cue: You are adding USB OTG, accessory detection or extcon-sm5502 to the SM5703 charger path and wonder why cable type comes from raw MUIC reads.
---

Decision: The SM5703 charger driver detects the cable type by reading only the MUIC device-type registers (@0x25 on i2c@13850000): DEV_T1 (0x0a) bit2 = USB SDP -> 450 mA input/charge; DEV_T3 (0x15) bit6 U200_CHG = wall charger (TA/DCP) -> 1650 mA input. It is triggered by the charger MFD IRQ (gpa2-7). It never writes the MUIC (no MANSW/CONTROL writes) and never reads the clear-on-read MUIC INT registers. Mainline extcon-sm5502 (which has a siliconmitus,sm5703-muic compatible) is NOT used.
Why: extcon-sm5502 detects TA only via DEV_TYPE1 bit6, while on the T585 wall chargers appear in DEV_T3 bit6; it also writes the USB switch/control registers, which risks the USB-ACM/NCM debug link on stage 1.
Scope: Charger chunk (battery chunk 3); revisit if USB OTG/host or accessory detection is needed.
