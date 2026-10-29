id: todo_t585_s2idle_resume_debug_plan_charger_poll_fix_rtcwake_2026_10_29
type: todo
area: workflow
perspective: user
created: 1793308192.65335
edges: [{"target_id": "learning_t585_s2idle_suspend_was_cover_closed_logind_lid_holdoff_2026_10_29", "edge_type": "derived_from"}, {"target_id": "learning_t585_s2idle_resume_works_5s_overnight_suspend_not_back_2026_10_29", "edge_type": "derived_from"}, {"target_id": "learning_t585_sm5703_chg_poll_runs_during_suspend_i2c_warn_temp_hot_2026_10_29", "edge_type": "derived_from"}]
cue: You want to make suspend usable on the SM-T585 (HandlePowerKey=suspend, overnight standby) and need to know what is left to do.
---

TODO (confirmed by the user): s2idle resume. In this order: (1) debug plan first, with hypotheses and predictions (why the overnight suspend did not come back); (2) charger poll fix (cancel sm5703_chg_poll in suspend, reschedule in resume); (3) rtcwake -m freeze tests with increasing duration (20 s, 2 min, 10 min, 1 h), measuring return, warnings, display delay and battery drain. Prerequisite for HandlePowerKey=suspend on the console. The suspend trigger is known (cover closed, logind lid handling), see learning_t585_s2idle_suspend_was_cover_closed_logind_lid_holdoff_2026_10_29.
