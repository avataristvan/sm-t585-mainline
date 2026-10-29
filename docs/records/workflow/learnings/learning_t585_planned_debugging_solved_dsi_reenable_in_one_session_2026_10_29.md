id: learning_t585_planned_debugging_solved_dsi_reenable_in_one_session_2026_10_29
type: learning
area: workflow
perspective: user
created: 1793307030.627392
edges: [{"target_id": "user_hw_debug_wants_written_plan_and_desk_research_first_2026_10_28", "edge_type": "confirms"}, {"target_id": "pattern_t585_runtime_switch_hypothesis_tests_one_diagnostic_kernel_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_dsim_video_mode_state_before_panel_commands_reenable_fixed_2026_10_29", "edge_type": "related"}]
cue: You are about to build a test kernel or flash an experiment on the tablet and it is tempting to just try something.
---

Observed: The DSI re-enable bug was solved in one session by planned debugging: written hypotheses with predictions plus one diagnostic kernel with runtime switches. Several rounds of trial and error before that had not solved it. The user explicitly prefers the planned way.
Cause: A written plan makes each experiment discriminate between hypotheses (H1 excluded, H2 confirmed), where "just try" runs only produce more variants of the same stuck state.
Evidence: docs/handoff-2026-10-28.md (experiments 1-7 vs. "Result 2026-10-29"), src/mainline 4ac46feab; user_hw_debug_wants_written_plan_and_desk_research_first_2026_10_28; pattern_t585_runtime_switch_hypothesis_tests_one_diagnostic_kernel_2026_10_29.
