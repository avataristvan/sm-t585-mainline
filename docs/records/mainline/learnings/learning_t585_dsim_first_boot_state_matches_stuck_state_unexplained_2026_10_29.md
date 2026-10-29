id: learning_t585_dsim_first_boot_state_matches_stuck_state_unexplained_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793307030.858674
edges: [{"target_id": "learning_t585_dsim_video_mode_state_before_panel_commands_reenable_fixed_2026_10_29", "edge_type": "related"}]
cue: Someone asks why the first boot worked without the DSIM fix, or you rework samsung_dsim_init.
---

Observed: OPEN, not needed for the fix. At the end of samsung_dsim_init the DSIM register state on the first boot is identical to the stuck re-enable state, yet on first boot all panel commands go out.
Cause: Unknown. Probably state outside the DSIM (DECON or PHY left running by the bootloader).
Evidence: kernel/out/dsi-diag-boot.log (c1 init-end) vs kernel/out/dsi-diag-base.log (local, not in git); learning_t585_dsim_video_mode_state_before_panel_commands_reenable_fixed_2026_10_29.
