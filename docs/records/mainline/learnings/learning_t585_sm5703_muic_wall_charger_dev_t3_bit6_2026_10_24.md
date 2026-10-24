id: learning_t585_sm5703_muic_wall_charger_dev_t3_bit6_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792857048.686313
edges: [{"target_id": "learning_t585_sm5703_raw_read_addresses_por_charger_undercharges_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_sm5703_charger_cable_detect_muic_readonly_2026_10_24", "edge_type": "related"}]
cue: You need to tell a PC USB port from a wall charger on the SM-T585 without a MUIC driver, or read SM5703 MUIC/MFD registers.
---

Observed: Without a MUIC driver, SM5703 MUIC DEV_T1 (0x0a) shows 0x04 on a PC USB port but 0x00 on wall chargers. Wall chargers show up in DEV_T3 (0x15) bit6 U200_CHG = 0x40 (downstream maps that to ATTACHED_DEV_TA). MANSW1 (0x13) is 0x25 on USB (D+/D- to USB, VBUS charger) and 0x01 on TA. The MUIC INT1/INT2 (0x03/0x04) and MFD INT1-4 (0x00-0x03) registers clear on read: do not read them while Lineage's drivers run.
Cause: Wall chargers are U200-type (DCP) and are reported in DEV_T3, not DEV_T1.
Evidence: kernel/tools/batt/rawdump.sh and battlog.sh readings on stage 1, 2026-10-24; see learning_t585_sm5703_raw_read_addresses_por_charger_undercharges_2026_10_24.
