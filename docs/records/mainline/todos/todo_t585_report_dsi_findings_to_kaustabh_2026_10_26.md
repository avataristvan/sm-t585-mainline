id: todo_t585_report_dsi_findings_to_kaustabh_2026_10_26
type: todo
area: mainline
perspective: user
created: 1793050044.158613
edges: [{"target_id": "learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26", "edge_type": "derived_from"}, {"target_id": "learning_t585_dsi_porch_pixels_not_byteclock_edge_strip_2026_10_26", "edge_type": "derived_from"}]
cue: You work on SM-T585 DSI upstreaming or the Exynos 7870 DSIM series and wonder what is still to be reported or sent to its author.
---

TODO: Report the two HW-verified SM-T585 DSI findings to Kaustabh Chakraborty <kauschluss@disroot.org>, author of the unmerged "[PATCH v5 0/3] Fixes and enhancements for Exynos (7870) DSIM bridge driver" (dri-devel, mail-archive msg626858-60):
(a) exynos7_drm_decon must start ENVID only after the DSI bridge chain and panel are enabled (we do it in decon_atomic_flush), otherwise the panel's LP init commands collide with the live pixel stream and the SoC hard-hangs.
(b) The Exynos7870 DSIM takes horizontal porches in pixels, not byte-clock units (mainline's conversion gives HSA=1 and a flickering strip at the line start; downstream dsim_reg_set_porch and the bootloader write pixels).
Open question to ask him: is (b) 7870-specific or valid for all older Exynos DSIMs (before the byte conversion, mainline wrote pixels for every SoC)? Also ask whether to send (a)/(b) as patches on top of his series.
Status: the user decides when to send; nothing sent yet (2026-10-26). The clean patches exist: DECON ENVID in atomic_flush, samsung-dsim has_porch_in_pixels for 7870 (packaged in linux-samsung-gtaxllte r6, HW-verified).
