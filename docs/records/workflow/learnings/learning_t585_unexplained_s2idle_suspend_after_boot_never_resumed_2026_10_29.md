id: learning_t585_unexplained_s2idle_suspend_after_boot_never_resumed_2026_10_29
type: learning
area: workflow
perspective: agent
created: 1793306202.615945
cue: You start an unattended test run or long job on the SM-T585 pmOS without gdm, or USB NCM and WiFi vanish minutes after boot.
---

Observed: OPEN, to investigate. With gdm disabled, pmOS on the SM-T585 entered s2idle suspend about 13 min after boot (journal: "Reached target Sleep", "PM: suspend entry (s2idle)") and never resumed; USB NCM and WiFi disappeared and the user had to power it on.
Cause: Unknown; who triggered the suspend (logind idle action, power key, something else) is not established. Rule until known: unattended test runs must check and inhibit suspend first (e.g. systemd-inhibit or masking sleep targets).
Evidence: journal of the session 2026-10-29, see docs/handoff-2026-10-28.md.
