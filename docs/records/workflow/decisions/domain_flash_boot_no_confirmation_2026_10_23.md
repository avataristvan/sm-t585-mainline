id: domain_flash_boot_no_confirmation_2026_10_23
type: domain
area: workflow
perspective: user
created: 1792778220.628629
edges: [{"target_id": "pattern_devsh_for_all_device_commands_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_devsh_for_all_device_commands_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_claude_auto_mode_denies_boot_flash_2026_10_23", "edge_type": "related"}]
cue: You are about to flash BOOT on the SM-T585 and CLAUDE.md says to confirm first while FOCUS.md says otherwise.
---

Decision: Flashing BOOT needs no confirmation in this bring-up (user, 2026-10-23). The auto-mode allow rule is in .claude/settings.local.json.
Why: Only BOOT is ever written, so the device cannot be bricked by a failed boot test; the confirmation only slowed iteration. This resolves the conflict between project CLAUDE.md ("always confirm") and FOCUS.md.
Scope: SM-T585 bring-up in this repo. CLAUDE.md still carries the old "always confirm" line (only the user edits it).
