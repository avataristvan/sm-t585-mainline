id: learning_t585_panel_module_in_initramfs_fixes_black_screen_h1_h2_prepared_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793380728.285166
edges: [{"target_id": "learning_t585_black_screen_after_hs200_decon_sysmmu_panel_module_simpledrm_2026_10_30", "edge_type": "derived_from"}, {"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}]
cue: Planning the module/initramfs layout of the display stack (exynos-drm, panel driver) on pmOS or packaging modules for the initramfs.
---

Observed: H1 result (3/3 boots): the panel module in the initramfs (/etc/mkinitfs/modules/*.modules + mkinitfs) loads via modalias at coldplug, panel attach comes 3.11 s before the root switch, and GDM finds card0 every time. pmOS mechanism for the package: a modules-initfs file in the device package (devicepkg-dev installs it to /usr/share/mkinitfs/modules/). H2 is prepared but not yet tested on hardware: CONFIG_DRM_EXYNOS=m in gtaxllte-pmos.config (overrides builtin.config =y) plus modules-initfs (exynosdrm, panel) in the device package pkgrel 4, kernel r16. sysmmu_decon disabled in the board DTS stays needed until the SysMMU chapter.
Cause: Loading the panel from the initramfs removes mechanism (2) of the black-screen problem; H2 (exynos-drm as module) aims at mechanism (3).
Evidence: docs/display-handover-plan-2026-10-30.md; 3 boots 2026-10-30.
