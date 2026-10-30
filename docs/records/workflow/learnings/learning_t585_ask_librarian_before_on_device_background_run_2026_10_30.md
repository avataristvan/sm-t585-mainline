id: learning_t585_ask_librarian_before_on_device_background_run_2026_10_30
type: learning
area: workflow
perspective: agent
created: 1793322710.64692
edges: [{"target_id": "learning_t585_background_logger_dies_with_ssh_use_systemd_run_2026_10_27", "edge_type": "confirms"}]
cue: You are about to start a background script or logger on the tablet over ssh.
---

Observed: The systemd-run lesson (learning_t585_background_logger_dies_with_ssh_use_systemd_run_2026_10_27) already existed but was not consulted before the E6 measurement; the mistake was repeated and the first E6 run was lost.
Cause: No librarian query before starting an on-device measurement.
Evidence: docs/cpuidle-plan-2026-10-29.md (E6), session 2026-10-30.
