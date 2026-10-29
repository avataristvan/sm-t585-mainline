id: learning_t585_s2idle_resume_works_5s_overnight_suspend_not_back_2026_10_29
type: learning
area: workflow
perspective: agent
created: 1793308183.473656
superseded_by: learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29
valid_until: 1793311953.755448
edges: [{"target_id": "learning_t585_s2idle_suspend_was_cover_closed_logind_lid_holdoff_2026_10_29", "edge_type": "related"}]
cue: You test or rely on s2idle suspend and resume on the SM-T585 and wonder whether it comes back, and how fast.
---

Observed: s2idle resume works in principle: a 5 s suspend (cover removed) resumed via the hall wakeup, the display came back after a few seconds, WiFi reconnected. The overnight suspend did not come back (fresh boot in the morning); cause open (battery drained? longer suspends hang?). Only s2idle is offered in mem_sleep, no cpuidle states.
Cause: The display delay is probably the suspend entry still finishing (ath10k key removal -110 about 3 s, fs sync 1 s), not the resume. The overnight failure is not explained.
Evidence: dmesg of the boot 2026-10-29 21:26, around 1781-1796 s.
