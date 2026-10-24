id: learning_devsh_flash_no_trailing_reboot_absolute_path_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792862244.003612
edges: [{"target_id": "learning_claude_auto_mode_denies_boot_flash_again_2026_10_24", "edge_type": "related"}]
cue: You hand the user a "!" dd flash command via devsh.py and want to append a reboot or use a relative path.
---

Observed: In the user's "!" dd flash command via devsh, a trailing `reboot` is not executed; the user reboots with the power button. Also use the absolute path to devsh.py in "!" commands, because the shell may sit in kernel/build.
Cause: not investigated why the trailing reboot is dropped; the shell cwd is the session's current directory.
Evidence: session 2026-10-24, flashes of kernel #28 and #29.
