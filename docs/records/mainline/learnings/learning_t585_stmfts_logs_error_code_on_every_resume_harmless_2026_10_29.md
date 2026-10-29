id: learning_t585_stmfts_logs_error_code_on_every_resume_harmless_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793311936.541932
edges: [{"target_id": "learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_chg_poll_runs_during_suspend_i2c_warn_temp_hot_2026_10_29", "edge_type": "related"}]
cue: You see stmfts "error code: 0x0dec00d0ba" in dmesg after a resume and wonder whether touch is broken.
---

Observed: stmfts logs "error code: 0x0dec00d0ba" once on every resume; touch keeps working.
Cause: Not investigated; harmless so far.
Evidence: s2idle tests 2026-10-29, docs/suspend-resume-plan-2026-10-29.md.
