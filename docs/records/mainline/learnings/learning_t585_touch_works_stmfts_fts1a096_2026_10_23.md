id: learning_t585_touch_works_stmfts_fts1a096_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792772540.744932
edges: [{"target_id": "learning_stmfts_fts1a096_not_command_compatible_2026_10_23", "edge_type": "related"}, {"target_id": "domain_stmfts_fts1a096_variant_2026_10_23", "edge_type": "related"}]
cue: You touch the SM-T585 touch path (stmfts, IRQ, axes) and wonder if touch works, why no IRQ fires, or whether to flip axes.
---

Observed: Touch WORKS on the SM-T585 (verified on hardware, 2026-10-23) with mainline stmfts and the FTS1A096 variant (compatible "st,fts1a096"; chip_info->configure per compatible). FTS1A096 power-on path: register reset B6 00 23 01, poll READ_ONE_EVENT 0x85 until event 0x10 (READY), 0xA1 clear stack, INT enable B6 00 1C 0x41.
The INT-enable VALUE is 0x41 (downstream INT_ENABLE), NOT 0x01: with 0x01 the chip never asserts the IRQ line (gpa0-4 stays high, 0 IRQs). This corrects the value "B6 00 1C 01" in learning_stmfts_fts1a096_not_command_compatible_2026_10_23.
Coordinates: portrait, origin top-left, x 0..~1200, y 0..~1920; no inversion or swap needed. Corners observed: (16,34) (1162,34) (1117,1896) (8,1880).
Cause: the interrupt-enable register is a bitmask; 0x01 leaves the event interrupt bit off.
Evidence: hardware test 2026-10-23 on SM-T585; src/mainline drivers/input/touchscreen/stmfts.c; downstream src/downstream-lineage-21/drivers/input/touchscreen/stm/fts7/.
