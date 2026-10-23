id: learning_stmfts_fts1a096_not_command_compatible_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792770176.67366
edges: [{"target_id": "learning_mainline_73_exynos7870_gap_2026_10_23", "edge_type": "contradicts"}, {"target_id": "todo_test_touchscreen_stmfts_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_touch_works_stmfts_fts1a096_2026_10_23", "edge_type": "related"}, {"target_id": "todo_records_under_git_2026_10_23", "edge_type": "related"}, {"target_id": "learning_gap_survey_compatible_is_hypothesis_2026_10_23", "edge_type": "related"}]
cue: You are bringing up the SM-T585 touchscreen on mainline stmfts and probe fails with -110, or you assume FTS1A096 is the same as FTS4.
---

Observed: The SM-T585 touch controller STM FTS1A096 (downstream fts7 driver, stm_ver 5) is NOT fully command-compatible with mainline stmfts. Mainline sends the 1-byte SYSTEM_RESET 0xA0 and waits for an IRQ. The FTS1A096 resets via the register write B6 00 23 01; the host then polls READ_ONE_EVENT 0x85 until event 0x10 (CONTROLLER_READY, observed bytes 10 00 00 00 00 0A 07 00). The chip's interrupt output stays disabled until B6 00 1C 01 is written. Result on hardware: "stmfts 1-0049: probe with driver stmfts failed with error -110". I2C to the chip works (same bus i2c@13840000, addr 0x49). These match mainline: event IDs, X/Y packing (event[1..3]), sense-on 0x93, tuning/calibration 0xA2-0xA4, sleep 0x90/0x91, READ_ALL 0x86.
Cause: different reset/ready/interrupt-enable handshake in the FTS1A096 firmware generation; the rest of the protocol is shared.
Evidence: device-dump/sm-t585/proc/dmesg.txt (fts_touch log); src/downstream-lineage-21/drivers/input/touchscreen/stm/fts7/fts_ts.c (fts_systemreset, fts_wait_for_ready, fts_interrupt_set). Contradicts the survey claim "same command set" in learning_mainline_73_exynos7870_gap_2026_10_23.
