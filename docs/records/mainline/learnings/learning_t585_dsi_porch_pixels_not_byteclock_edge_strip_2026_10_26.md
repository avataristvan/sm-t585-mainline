id: learning_t585_dsi_porch_pixels_not_byteclock_edge_strip_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1793048762.518716
edges: [{"target_id": "learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}]
cue: After switching from the bootloader picture to exynos-drm the SM-T585 panel shows a 1-2 px flickering strip at the line start.
---

Observed: HW-verified 2026-10-26. A 1-2 px flickering strip at the line start (left edge in portrait, where the dmesg "[" sits) appears after switching from the bootloader picture to exynos-drm. Bisected with runtime params: writing the porches in pixels alone fixes it. The bootloader PLL (p3 m226 s1, VCO 1958 vs mainline p3 m113 s0) and the bootloader PHY timings (0x070c/0x082a0d09/0x00090f0c vs computed 0x060c/0x05200e07/0x00050e09) are not needed. Writing the porch registers live while video runs has no effect; they must be set before video start.
Cause: samsung-dsim converts HFP/HBP/HSA from pixels to byte-clock units and subtracts 6 bytes of overhead (here HFP 87, HBP 19, HSA 1). The 7870 DSIM wants the porches in pixels, as downstream dsim_reg_set_porch and the bootloader write them (MHPORCH 0x00780020 = HFP 120/HBP 32, MSYNC HSA 8).
Other bootloader-vs-mainline DSIM differences seen, not causal: CONFIG 0x6444747f vs 0xf4c4707f (bit23 HSE_DISABLE, because mainline's MIPI_DSI_MODE_VIDEO_HSE flag sets the disable bit; bit31 non-continuous clock; bit28; bit10 Q_CHANNEL), CMD_CONFIG bit20 CMD_CTRL_SEL, MVPORCH CMDALLOW 13/STABLE_VFP 1 vs 15/16.
Evidence: HW tests 2026-10-26 evening (SFR dumps of the bootloader state before modprobe, runtime params); related learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26.
