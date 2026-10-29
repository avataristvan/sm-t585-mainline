id: learning_t585_s2idle_suspend_was_cover_closed_logind_lid_holdoff_2026_10_29
type: learning
area: workflow
perspective: agent
created: 1793308182.82014
edges: [{"target_id": "learning_t585_unexplained_s2idle_suspend_after_boot_never_resumed_2026_10_29", "edge_type": "supersedes"}]
cue: The SM-T585 suspends by itself shortly after boot or while you test, and you suspect idle action, power key or a driver.
---

Observed: The s2idle suspends that looked unexplained were caused by the cover: the user closed it (journal: systemd-logind "Lid closed." then "Suspending...", HandleLidSwitch=suspend is the default). Two morning boots suspended exactly 30 s after logind start without a new lid message. The user does not remember the cover state; boots with the cover off never suspended. Hall polarity on close is correct.
Cause: logind HoldoffTimeoutSec=30s: with the lid already closed at boot, logind acts on the lid state once the holdoff ends. No idle action and no power key were involved.
Evidence: journal of 2026-10-29 (systemd-logind lines); replaces learning_t585_unexplained_s2idle_suspend_after_boot_never_resumed_2026_10_29, whose rule still holds (unattended runs: check or inhibit suspend first, now also: check the cover state, or set HandleLidSwitch=ignore for tests).
