id: learning_claude_auto_mode_denies_boot_flash_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792785321.17311
edges: [{"target_id": "domain_flash_boot_no_confirmation_2026_10_23", "edge_type": "related"}]
cue: You are about to flash BOOT with dd via devsh.py in Claude Code auto mode and the permission classifier denies it.
---

Observed: In Claude Code auto mode the classifier denied the BOOT flash (dd to /dev/mmcblk0p9 via devsh.py) as "Irreversible Local Destruction", despite the allow rule in .claude/settings.local.json. The user ran the command themselves via the "!" prefix. Reboot (reboot -f) and module loading were not blocked.
Cause: The auto-mode classifier judges the command independently of the allow rule.
Evidence: session 2026-10-23, audio chunk 3a. How to apply: when flashing, hand the user the exact "! python3 -I kernel/tools/devsh.py ..." command with the expected sha1 instead of retrying.
