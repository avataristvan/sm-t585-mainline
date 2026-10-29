id: learning_t585_sm5703_chg_poll_runs_during_suspend_i2c_warn_temp_hot_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793308183.84767
edges: [{"target_id": "todo_t585_sm5703_charger_review_findings_2026_10_24", "edge_type": "related"}]
cue: You run suspend tests or touch sm5703_charger.c on the SM-T585 and see i2c "Transfer while suspended" warnings or a false hot battery.
---

Observed: In our sm5703_charger the sm5703_chg_poll delayed work keeps running during system suspend. It logs "i2c i2c-4/i2c-1: Transfer while suspended" WARNINGs (it also reads the fuel gauge), the battery temperature read fails (-110) and is reported as "hot", which could stop charging. Also seen around suspend/resume: stmfts "error code 0x0dec00d0ba" once, ath10k "hif read32 not supported" once, and "samsung-pinctrl: No retention data configured bank with external wakeup interrupt" at suspend.
Cause: No suspend handling: the poll work is not cancelled in suspend. Fix (planned, not done): cancel the poll work in suspend, reschedule it in resume via dev_pm_ops.
Evidence: dmesg of the s2idle tests 2026-10-29; see todo_t585_s2idle_resume_debug_plan_charger_poll_fix_rtcwake_2026_10_29.
