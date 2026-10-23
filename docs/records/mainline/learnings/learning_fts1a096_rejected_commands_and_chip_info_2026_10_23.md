id: learning_fts1a096_rejected_commands_and_chip_info_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792772532.267338
edges: [{"target_id": "learning_t585_touch_works_stmfts_fts1a096_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stmfts_fts1a096_not_command_compatible_2026_10_23", "edge_type": "related"}]
cue: You see "0f ba d0 00 c0 de" or odd errors in stmfts logs on the SM-T585, or sysfs chip_id/fw values look wrong.
---

Observed: FTS1A096 error event "0f ba d0 00 c0 de 00 00" ("BAD0 C0DE") means command rejected. 0x90 SLEEP_IN and 0x91 SLEEP_OUT are rejected while sensing is on; mainline stmfts sends SLEEP_IN after power-on and SLEEP_OUT on runtime resume, giving one harmless error log each. 0x80 READ_INFO is not supported (returns zeros/garbage), so mainline sysfs chip_id 0x455 / fw 5712 are bogus. Real info: register read B6 00 07 -> "39 80 01 84 06 00" (downstream fts_read_chip_id; firmware 0x0684, config 0x070A). 0xA2 force calibration answers with status events 16 05 / 16 06. After reset the chip emits error events 0f 06 10 / 0f 06 20 before READY (meaning unknown, also harmless).
Cause: FTS1A096 firmware implements a narrower command set than FTS4; unsupported commands answer with the BAD0 C0DE error event.
Evidence: hardware captures 2026-10-23 on SM-T585; downstream fts7 fts_read_chip_id; learning_t585_touch_works_stmfts_fts1a096_2026_10_23.
