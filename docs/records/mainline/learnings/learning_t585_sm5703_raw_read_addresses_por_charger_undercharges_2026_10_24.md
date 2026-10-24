id: learning_t585_sm5703_raw_read_addresses_por_charger_undercharges_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792857048.475428
edges: [{"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}, {"target_id": "learning_i2cx_and_evdecode_tools_2026_10_23", "edge_type": "related"}]
cue: You are about to write the SM5703 fuel-gauge or charger driver, or wonder why the T585 does not charge on stage 1.
---

Observed: On mainline stage 1 (kernel #26 + DTB with i2c0/i2c2/i2c4 enabled, no child nodes, no drivers) all three SM5703 parts answer via kernel/tools/i2cx: fuel gauge @0x71 on i2c@13830000, MUIC @0x25 on i2c@13850000, MFD/charger @0x49 on i2c@13870000. The FG is already initialised from Lineage/TWRP (reg 0x10 low byte 0x07 = DISABLE_RE_INIT). FG words are little-endian; mV = ((w>>8)&7)*1000 + (w&255)*1000/256. The charger sits at chip POR values: VBUSCNTL 0x0d=0x07 (input limit 100+50n = 450 mA), CHGCNTL2 0x0f=0x07 (fast charge 450 mA), CHGCNTL3 0x10 BATREG=0x16 (4.34 V). Stage 1 with display draws about 780 mA from the battery, so with a 450 mA input limit the battery still discharges on a PC port (about -200 mA) and barely charges on a wall charger (about +70 mA).
Cause: No charger driver programs the SM5703, so POR limits stay in force.
Evidence: tools kernel/tools/batt/rawdump.sh, battlog.sh (logger with temperature safety net and DCP-triggered limits), setchg.sh; boot image kernel/out/boot-stage1.img (sha1 a03d00880f205167191efc1fe83c3144de85fa2e). Confirms the user's under-charging suspicion in todo_sm5703_charger_fuel_gauge_2026_10_23.
