id: learning_t585_debug_plan_with_predictions_decided_c2_hypotheses_in_90_min_2026_10_30
type: learning
area: workflow
perspective: user
created: 1793341581.059938
edges: [{"target_id": "learning_t585_planned_debugging_solved_dsi_reenable_in_one_session_2026_10_29", "edge_type": "confirms"}]
cue: You decide whether to write a hypotheses-and-predictions plan before hardware experiments.
---

Observed: The "debug plan before HW experiments" practice (hypotheses + predictions + run order) paid off again: five runs plus one reverting run decided H4/H5/H6 of the C2 interrupt loss in about 90 minutes with one reset.
Cause: Predictions per hypothesis let each run discard or confirm one cause; the order put cheap and staged runs first.
Evidence: docs/cpuidle-plan-2026-10-29.md "Debug plan 2 results"; learning_t585_planned_debugging_solved_dsi_reenable_in_one_session_2026_10_29.
