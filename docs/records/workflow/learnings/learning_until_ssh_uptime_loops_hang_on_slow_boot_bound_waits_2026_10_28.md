id: learning_until_ssh_uptime_loops_hang_on_slow_boot_bound_waits_2026_10_28
type: learning
area: workflow
perspective: agent
created: 1793226636.020998
cue: You write a shell wait loop for the tablet to come back after a reboot (until ssh ... uptime).
---

Observed: `until ssh ... 'uptime < N'` style loops miss slow boots (the uptime window passes before ssh answers) and then hang forever.
Cause: The condition tests a time window instead of the state the next step needs.
Evidence: session 2026-10-28. Instead: bound every wait (count or timeout) and check the real state (boot id, kernel release, service up).
