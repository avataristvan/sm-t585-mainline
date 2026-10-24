id: pattern_poll_shell_after_reboot_f_under_10s_2026_10_24
type: pattern
area: workflow
perspective: user
created: 1792823584.846073
edges: [{"target_id": "learning_stage1_flash_via_ncm_wget_verified_2026_10_23", "edge_type": "related"}, {"target_id": "learning_speech_tests_user_starts_late_record_12s_2026_10_24", "edge_type": "related"}]
cue: You reboot the SM-T585 on stage 1 and are about to sleep a long fixed time before reconnecting.
---

Rule: After `reboot -f` on stage 1, poll the shell every ~2 s instead of using fixed long sleeps.
When: Every reboot/flash cycle on the SM-T585 stage 1.
Why: The user said 2026-10-24: "ein reboot geht unter 10 sec." Long fixed sleeps waste time.
