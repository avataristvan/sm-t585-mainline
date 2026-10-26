id: learning_claude_bang_prefix_no_sudo_root_commands_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792924152.532602
edges: [{"target_id": "pattern_user_runs_audio_test_with_timed_register_write_2026_10_24", "edge_type": "related"}, {"target_id": "learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23", "edge_type": "related"}]
cue: You are about to have a root command run on the host, such as a network setup script, from inside a Claude Code session.
---

Observed: sudo does not work through Claude Code's "!" prefix, because there is no terminal for the password prompt. Root commands on the host (for example kernel/tools/host-nat.sh) are run by the user in a normal terminal, not through "!".
Cause: The "!" prefix runs the command without a terminal, so sudo cannot ask for the password and fails.
Evidence: session 2026-10-25; kernel/tools/host-nat.sh (header: run as root); learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23 (an earlier nmcli step had to avoid sudo for the same reason).
