id: pattern_devsh_for_all_device_commands_2026_10_23
type: pattern
area: workflow
perspective: user
created: 1792774428.357589
edges: [{"target_id": "learning_stage1_flash_via_ncm_wget_verified_2026_10_23", "edge_type": "related"}, {"target_id": "domain_flash_boot_no_confirmation_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_devsh_first_ttyacm_and_stale_query_2026_10_23", "edge_type": "related"}]
cue: You need to run a command on the SM-T585 stage-1 shell, including flashing BOOT with dd, and wonder which tool is allowed.
---

Rule: Use `python3 -I kernel/tools/devsh.py <command>` for all device commands on the stage-1 shell, including flashing (dd to BOOT).
When: any command on the SM-T585 while stage 1 runs. devsh.py talks to /dev/ttyACM0 via the host cdc_acm and needs no pyusb; acm-shell.py needs pyusb, which is not installed.
Why: The auto-mode classifier blocked dd-to-BOOT over the remote shell. The user decided (2026-10-23) to allow it permanently: .claude/settings.local.json allows "Bash(python3 -I kernel/tools/devsh.py *)" (relative and absolute path). Flashing still needs the user's confirmation per project CLAUDE.md.
