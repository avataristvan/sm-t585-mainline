id: learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793311936.054281
edges: [{"target_id": "learning_t585_s2idle_resume_works_5s_overnight_suspend_not_back_2026_10_29", "edge_type": "supersedes"}, {"target_id": "learning_t585_sm5703_chg_poll_runs_during_suspend_i2c_warn_temp_hot_2026_10_29", "edge_type": "fixes"}]
cue: You rely on s2idle suspend/resume on the SM-T585, plan long suspend tests, or a long suspend does not come back, and wonder where to start.
---

Observed: After src/mainline 479f8fe10 (sm5703 charger and fuel gauge poll works queued on system_freezable_power_efficient_wq) s2idle resume works. Packaged as linux-samsung-gtaxllte r10 and installed. RTC wake after 20 s, 2 min and 10 min, cover wake, and power-key wake with the cover closed all return; no "Transfer while suspended", thermal zone stays normal, WiFi and display come back. The hypothesis "wake source" is excluded. The original overnight non-return was not reproduced: the poll fix is the plausible but unproven cause. The overnight and 1 h checks were dropped by user decision ("die lange Zeit bringt keine Erkenntnisse, die wir nicht schon nach Sekunden oder Minuten sehen"). If a long suspend ever fails to come back, start with the charger/fuel gauge poll works.
Cause: The freezable workqueue is frozen before device suspend, so the polls no longer touch i2c while suspended. CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y makes the queue unbound.
Evidence: docs/suspend-resume-plan-2026-10-29.md "Result"; commit 479f8fe10 in src/mainline; main c046c43.
