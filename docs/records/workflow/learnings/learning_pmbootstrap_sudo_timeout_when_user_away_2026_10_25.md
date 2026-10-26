id: learning_pmbootstrap_sudo_timeout_when_user_away_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792956374.176662
edges: [{"target_id": "domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25", "edge_type": "related"}]
cue: pmbootstrap install or build fails with a losetup error after the build succeeded, and you are away from the terminal.
---

Observed: sudo inside pmbootstrap times out when the user is away from the terminal. The losetup step then fails after a successful build.
Cause: sudo waits for a password at the terminal and gives up when nobody answers.
Evidence: pmbootstrap install run, 2026-10-25.
