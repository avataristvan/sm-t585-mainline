id: pattern_stage1_background_script_no_stdout_set_e_2026_10_25
type: pattern
area: workflow
perspective: the-coder
created: 1792925768.52545
edges: [{"target_id": "learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25", "edge_type": "derived_from"}, {"target_id": "learning_t585_pstore_needs_printk8_in_init_2026_10_24", "edge_type": "related"}]
cue: You are adding a script that stage-1 init starts, and it uses echo, redirections or set -e while no console exists yet.
---

Rule: A script that stage-1 init starts must not depend on stdout or stderr. Redirect its streams to /dev/null or /dev/kmsg, and make a diagnostic echo non-fatal when the script runs under set -e. Stage 1 observes through /dev/kmsg, which reaches pstore only with printk set to 8 in init.
When: init starts the script before a console exists, e.g. rootfs-up (`</dev/null >/dev/null 2>/dev/kmsg`).
Why: At boot init has no stdout, so a plain echo fails, and with set -e the script ends silently halfway. This is what happened to rootfs-up (learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25). The rule applies to any script started this way, foreground or background.
