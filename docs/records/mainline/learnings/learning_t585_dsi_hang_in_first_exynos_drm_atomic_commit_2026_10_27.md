id: learning_t585_dsi_hang_in_first_exynos_drm_atomic_commit_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793044908.891797
edges: [{"target_id": "learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27", "edge_type": "related"}, {"target_id": "todo_t585_dsi_decisions_after_hw_test_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_pmos_boot_entry_conf_editable_for_one_off_cmdline_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26", "edge_type": "related"}]
cue: You debug the SM-T585 DSI/DECON hang and need to know where it happens and how to reproduce and capture it on demand.
---

Observed: The DSI hang happens in the first exynos-drm atomic commit (fbdev modeset of crtc-0, mode 1200x1920@60, 159.6 MHz, plane-0 FB), about 10 s after the panel module attaches. Probe/bind and panel attach are fine. Reproducible on demand: DSI-on DTB, then `modprobe panel_samsung_gtaxllte_hx8279d`, captured with live `dmesg -w` over ssh plus drm.debug=0x1f. console-ramoops did not keep the hang log, so live ssh capture is needed.
Cause: Not known yet; analysis in progress in docs/dsi-hang-analysis-2026-10-27.md.
Evidence: HW tests 2026-10-27; docs/dsi-hang-analysis-2026-10-27.md; extends learning_t585_decon_dsi_enabled_hard_hangs_before_gdm_2026_10_27.
