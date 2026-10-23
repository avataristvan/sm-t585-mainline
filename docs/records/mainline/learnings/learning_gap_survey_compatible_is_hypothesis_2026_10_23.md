id: learning_gap_survey_compatible_is_hypothesis_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792773116.493776
edges: [{"target_id": "learning_mainline_73_exynos7870_gap_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_stmfts_fts1a096_not_command_compatible_2026_10_23", "edge_type": "derived_from"}]
cue: You plan bring-up of a chip that a gap survey marks as "mainline driver exists / compatible".
---

Observed: learning_mainline_73_exynos7870_gap_2026_10_23 said for the touch "FTS1A096: stmfts, same command set, likely compatible". On hardware only the event format and most commands matched; reset, INT enable (0x41), sleep commands and 0x80 READ_INFO differ.
Cause: the survey compared by name and reading, not by testing on the device.
Lesson: A gap survey's "compatible" for a mainline driver is a hypothesis until tested on hardware; record it as unverified.
Evidence: learning_stmfts_fts1a096_not_command_compatible_2026_10_23, learning_t585_touch_works_stmfts_fts1a096_2026_10_23.
