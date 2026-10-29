id: learning_t585_dsi_reenable_serror_header_fifo_not_waited_fifoctrl_bits_2026_10_28
type: learning
area: mainline
perspective: agent
created: 1793226641.640804
superseded_by: learning_t585_dsim_video_mode_state_before_panel_commands_reenable_fixed_2026_10_29
valid_until: 1793306207.215268
edges: [{"target_id": "learning_t585_samsung_dsim_transfer_needs_prepare_prev_first_2026_10_26", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26", "edge_type": "related"}, {"target_id": "pattern_t585_crash_iteration_panic5_boot_entry_fb0_blank_pstore_2026_10_28", "edge_type": "related"}]
cue: SM-T585 panel unblank panics with SError in samsung_dsim_transfer_start, or you touch the 7870 DSIM header FIFO wait.
---

Observed: OPEN BUG. Blank works; unblank gives an SError panic in samsung_dsim_transfer_start, called from gtaxl_prepare. Mechanism: the first command header stays in the DSIM header FIFO; mainline does not wait on the 7870 (wait_for_hdr_fifo=0), the FIFO overflows and the SError follows. The first boot works only because it starts from the bootloader's state.
Cause: On the 7870 the FIFOCTRL header empty/full flags are bit 10/11 (downstream regs-dsim.h), while mainline checks bit 22/23, so the wait can never work there; that is why wait_for_hdr_fifo=0 for 7870 (a mainline bug, worth upstreaming). Downstream order: program config + resolution + porches, then STANDBY + HS clock, then panel init, then DECON. Downstream sends no panel commands at disable in video mode. Shadow registers are off and are not the cause. Interim: GNOME Blank Screen = Never.
Evidence: experiments 1-7 and the plan in docs/handoff-2026-10-28.md; WIP patch kernel/out/dsi-reenable-wip.patch; downstream regs-dsim.h in src/downstream-lineage-21.
