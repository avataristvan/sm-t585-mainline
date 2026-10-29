id: learning_t585_dsim_video_mode_state_before_panel_commands_reenable_fixed_2026_10_29
type: learning
area: mainline
perspective: agent
created: 1793306201.909956
edges: [{"target_id": "pattern_t585_runtime_switch_hypothesis_tests_one_diagnostic_kernel_2026_10_29", "edge_type": "derived_from"}, {"target_id": "learning_t585_dsi_reenable_serror_header_fifo_not_waited_fifoctrl_bits_2026_10_28", "edge_type": "supersedes"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_planned_debugging_solved_dsi_reenable_in_one_session_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_dsim_first_boot_state_matches_stuck_state_unexplained_2026_10_29", "edge_type": "related"}, {"target_id": "todo_t585_package_linux_r9_dsi_reenable_remove_blank_never_2026_10_29", "edge_type": "related"}]
cue: SM-T585 DSI panel unblank or re-enable hits FIFO timeouts or SError, or you reorder samsung_dsim init versus panel prepare.
---

Observed: The Exynos7870 DSIM in video mode keeps the first command packet header in the FIFO unless resolution, porches and stand-by (MDRESOL/porch regs, SFRCTRL STAND_BY) are programmed BEFORE the panel commands. Mainline programs them only in atomic_enable, after panel prepare. The first boot worked only thanks to the bootloader's state. With the fix, 10/10 and 20/20 blank/unblank cycles ran with zero FIFO timeouts; GNOME power key, auto-off and lock screen verified by the user.
Cause: Wrong init order for this variant. Downstream (dsim_reg_init + dsim_reg_start) sets display mode and stand-by before panel init. Two mainline gaps: the header-FIFO empty flag is bit 10 on the 7870 (mainline checks bit 22), so the wait was disabled; and display mode/stand-by are not set at the end of samsung_dsim_init.
Evidence: Diagnostic kernel with runtime switches (see pattern_t585_runtime_switch_hypothesis_tests_one_diagnostic_kernel_2026_10_29): base 386 FIFO timeouts; H1 keep runtime PM on (lost state) 434, excluded; H2 display mode + stand-by at end of samsung_dsim_init 0 timeouts. Fix = two uncommitted patches in src/mainline: per-variant sfr_header_empty_bit (7870: bit 10) with wait_for_hdr_fifo=1 for 7870, and has_display_mode_on_init for 7870. Both upstream-worthy. Details in docs/handoff-2026-10-28.md ("Status 2026-10-29", "Result 2026-10-29").
