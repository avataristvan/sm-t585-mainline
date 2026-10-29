id: learning_t585_s2idle_keeps_monotonic_clock_running_journald_udevd_watchdog_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793311936.303683
edges: [{"target_id": "learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29", "edge_type": "related"}]
cue: journald or udevd show "Failed with result watchdog" after resume, or you decide whether to add PSCI cpuidle idle-states.
---

Observed: After s2idle suspends longer than 3 min, systemd restarts journald and udevd with "Failed with result 'watchdog'" (WatchdogSec=3min). Harmless, the services restart.
Cause: The kernel clock (dmesg timestamps, monotonic) keeps running through s2idle on this device. There is no cpuidle driver and no idle-states, so timekeeping is not suspended and the frozen services look hung to the watchdog. An argument for PSCI cpuidle idle-states (also for power).
Evidence: session 2026-10-29, see docs/suspend-resume-plan-2026-10-29.md; sibling learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29.
