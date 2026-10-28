id: learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1793048762.296147
edges: [{"target_id": "learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27", "edge_type": "supersedes"}, {"target_id": "learning_t585_dsi_hang_in_first_exynos_drm_atomic_commit_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_dsi_reenable_serror_header_fifo_not_waited_fifoctrl_bits_2026_10_28", "edge_type": "related"}]
cue: The SM-T585 hard-freezes in the first exynos-drm commit while the DSI panel is initialised, and you suspect DSIM, PLL or panel timing.
---

Observed: HW-verified 2026-10-26. The DSI hard hang on the first exynos-drm commit is caused by DECON starting the video stream (VIDCON0 ENVID|ENVID_F in decon_commit, called from the CRTC atomic_enable) BEFORE the samsung-dsim init and the panel prepare. The ~270 LPM init commands then collide with the live pixel stream: each LPM write took 5-7 ms (it is only sent in blanking) and the SoC hard-freezes after a random number of packets (1 ms gap: froze at packet 62; 20 ms gaps: survived). Fix verified: defer ENVID to decon_atomic_flush (commit_tail_rpm runs it after bridge pre_enable/enable and panel prepare/enable); it survives with zero delays, 268 init commands in 115 ms. A/B: defer off -> freeze again. Downstream has the same order (decon_reg_start last). DSIM init, PLL and SWRST were instrumented and are innocent.
Cause: The Exynos 7870 DSIM cannot interleave LP commands safely with a running DECON stream during panel init (H3 "DECON enable order" of docs/dsi-hang-analysis-2026-10-27.md confirmed; H1 and H2 not the cause).
Evidence: HW tests 2026-10-26 evening with runtime debug params; docs/dsi-hang-analysis-2026-10-27.md; supersedes the open state of learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27.
