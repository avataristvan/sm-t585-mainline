id: learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793311936.054281
edges: [{"target_id": "learning_t585_s2idle_resume_works_5s_overnight_suspend_not_back_2026_10_29", "edge_type": "supersedes"}, {"target_id": "learning_t585_sm5703_chg_poll_runs_during_suspend_i2c_warn_temp_hot_2026_10_29", "edge_type": "fixes"}, {"target_id": "todo_t585_s2idle_resume_debug_plan_charger_poll_fix_rtcwake_2026_10_29", "edge_type": "related"}]
cue: You rely on s2idle suspend/resume on the SM-T585, or touch the charger/fuel gauge poll works, and wonder if resume is solid.
---

Observed: After src/mainline 479f8fe10 (sm5703 charger and fuel gauge poll works queued on system_freezable_power_efficient_wq) s2idle resume works. Packaged as linux-samsung-gtaxllte r10 and installed. RTC wake after 20 s, 2 min and 10 min, cover wake, and power-key wake with the cover closed all return; no "Transfer while suspended", thermal zone stays normal, WiFi and display come back. The hypothesis "wake source" is excluded. The overnight non-return is not reproduced; the long-term test is the next night with the cover.
Cause: The freezable workqueue is frozen before device suspend, so the polls no longer touch i2c while suspended. CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y makes the queue unbound.
Evidence: docs/suspend-resume-plan-2026-10-29.md "Result"; commit 479f8fe10 in src/mainline.
