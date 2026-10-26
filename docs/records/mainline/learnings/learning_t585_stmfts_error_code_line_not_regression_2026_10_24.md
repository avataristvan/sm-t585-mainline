id: learning_t585_stmfts_error_code_line_not_regression_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792875053.010163
edges: [{"target_id": "learning_fts1a096_rejected_commands_and_chip_info_2026_10_23", "edge_type": "related"}]
cue: You read stmfts "error code" lines in SM-T585 boot logs and wonder whether the touch driver has regressed.
---

Observed: On the SM-T585, stmfts logs "error code: 0x0dec00d0ba" twice during probe at boot, and sometimes at runtime. The same line appears in older logs. Touch IRQs still arrive.
Cause: Not a regression: the line predates the current tree and does not stop touch. What the code is, is not established; it is not confirmed to be the same as the FTS1A096 error event BAD0 C0DE.
Evidence: Boot logs reported by the user on 2026-10-24 (older and current kernels; no source file was checked by the archivist); learning_fts1a096_rejected_commands_and_chip_info_2026_10_23 for the chip's error events.
