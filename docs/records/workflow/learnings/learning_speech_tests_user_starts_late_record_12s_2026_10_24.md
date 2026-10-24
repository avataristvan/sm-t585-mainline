id: learning_speech_tests_user_starts_late_record_12s_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792826507.560367
edges: [{"target_id": "pattern_poll_shell_after_reboot_f_under_10s_2026_10_24", "edge_type": "related"}]
cue: You run a speech or mic test where the user must talk, and the capture looks silent.
---

Observed: In speech tests the user only starts speaking once they read the chat message, typically 6-7 s after the tool call starts; two "silent" headset-mic tests were this artefact. The user can also reach the stage-1 device via telnet long before fixed post-reboot sleeps end.
Cause: the test window began before the user reacted.
Instead: record >= 12 s and judge only the tail, or let the user say when ready; poll the shell after a reboot instead of sleeping fixed times.
Evidence: session 2026-10-24 headset mic tests; see pattern_poll_shell_after_reboot_f_under_10s_2026_10_24.
