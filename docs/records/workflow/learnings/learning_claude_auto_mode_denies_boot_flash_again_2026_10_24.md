id: learning_claude_auto_mode_denies_boot_flash_again_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792830835.592368
edges: [{"target_id": "learning_claude_auto_mode_denies_boot_flash_2026_10_23", "edge_type": "confirms"}, {"target_id": "learning_devsh_flash_no_trailing_reboot_absolute_path_2026_10_24", "edge_type": "related"}]
cue: You are about to flash BOOT with dd via devsh.py in auto mode, again, and expect the allow rule in settings.local.json to be enough.
---

Observed: On 2026-10-24 the auto-mode classifier again denied the BOOT dd via devsh.py ("Remote Shell Writes") despite the settings.local.json allowance. The user ran the flash themselves with "! python3 -I tools/devsh.py ...".
Cause: The classifier judges the command independently of the allow rule. Note: the "!" shell runs in the session's current working directory, which may be kernel/, so give the devsh.py path relative to that directory.
Evidence: kernel #12 flash, session 2026-10-24; confirms learning_claude_auto_mode_denies_boot_flash_2026_10_23.
