id: todo_t585_s2idle_resume_debug_plan_charger_poll_fix_rtcwake_2026_10_29
type: todo
area: workflow
perspective: user
created: 1793308192.65335
edges: [{"target_id": "learning_t585_s2idle_suspend_was_cover_closed_logind_lid_holdoff_2026_10_29", "edge_type": "derived_from"}, {"target_id": "learning_t585_s2idle_resume_works_5s_overnight_suspend_not_back_2026_10_29", "edge_type": "derived_from"}, {"target_id": "learning_t585_sm5703_chg_poll_runs_during_suspend_i2c_warn_temp_hot_2026_10_29", "edge_type": "derived_from"}, {"target_id": "learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29", "edge_type": "related"}]
cue: You want to make suspend usable on the SM-T585 (HandlePowerKey=suspend, overnight standby) and need to know what is left to do.
---

TODO (confirmed by the user): s2idle resume. Status 2026-10-29 night: (1) debug plan done; (2) charger poll fix done (479f8fe10, linux-samsung-gtaxllte r10); (3) rtcwake -m freeze tests done for 20 s, 2 min and 10 min (all return, see learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29). Left: the overnight check with the cover closed (next night) and optionally 1 h plus battery drain measurement. Prerequisite for HandlePowerKey=suspend on the console. The suspend trigger is known (cover closed, logind lid handling), see learning_t585_s2idle_suspend_was_cover_closed_logind_lid_holdoff_2026_10_29.
