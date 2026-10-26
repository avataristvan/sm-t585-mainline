id: learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793045943.085218
superseded_by: learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26
valid_until: 1793048763.207332
edges: [{"target_id": "learning_t585_dsi_hang_in_first_exynos_drm_atomic_commit_2026_10_27", "edge_type": "related"}]
cue: You debug the SM-T585 DSI/DECON hang and wonder if SysMMU, PLL rate, simpledrm or the Kaustabh DSIM patches are the cause.
---

Observed: HW-verified 2026-10-27. Ruled out as sole cause of the DSI hang: SysMMU (sysmmu_decon CTRL 0x14860000 reads 0 = bypass; CONFIG_EXYNOS_IOMMU off), PLL frequency alone (burst 500 MHz like j6lte also hangs), simpledrm coexistence alone. The bootloader leaves the DSIM PLL at p3 m226 s1 (PLLCTRL 0x00806711, VCO 1958 MHz /2); mainline's 7870 driver data limits m<=125 / VCO<=1500 MHz and picks p3 m113 s0 (VCO 979). With Kaustabh Chakraborty's unmerged "[PATCH v5 0/3] Fixes and enhancements for Exynos (7870) DSIM bridge driver" applied (MFLUSH_VS, IRQ-based PLL-stable wait, aperture removal before component_bind_all so simpledrm is kicked at bind), the clean DRM debug log ends at "enabling [CRTC:41:crtc-0]" -> "pre-enabling bridges" -> freeze. So the hang is in samsung-dsim pre_enable or in the panel prepare, with DECON already enabled.
Cause: Not known yet; remaining suspects are samsung-dsim pre_enable and the panel prepare path.
Evidence: HW tests 2026-10-27; docs/dsi-hang-analysis-2026-10-27.md; state in docs/handoff-2026-10-27.md; extends learning_t585_dsi_hang_in_first_exynos_drm_atomic_commit_2026_10_27.
