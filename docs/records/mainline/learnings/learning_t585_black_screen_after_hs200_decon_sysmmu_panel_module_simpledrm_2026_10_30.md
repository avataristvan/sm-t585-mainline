id: learning_t585_black_screen_after_hs200_decon_sysmmu_panel_module_simpledrm_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793380728.040202
edges: [{"target_id": "domain_t585_emmc_hs200_exynos7870_drv_data_extended_tmout_2026_10_30", "edge_type": "related"}]
cue: The screen stays black after boot, GDM says "No GPUs with outputs found" / primaryMonitor is null, or a leftover simpledrm card1 shows up.
---

Observed: Since HS200 (faster boot, GDM at ~19-21 s) the screen could stay black after boot. Three mechanisms: (1) decon has iommus = <&sysmmu_decon>, the sysmmu node is enabled but CONFIG_EXYNOS_IOMMU is off, so decon defers until the deferred-probe timeout (~24 s). (2) The panel driver is a module loaded from the rootfs (attach 12.4 s, root switch 6.3 s). (3) exynos-drm's aperture_remove_conflicting_devices only removes simpledrm if simpledrm registered first; both are built in, exynos links before sysfb/, and sysfb_disable() does not cover DT simple-framebuffer nodes. Once (1) is gone, exynos-drm registers at 0.238 s and simpledrm at 0.239 s stays as a second card that mutter adds (card1, connector Unknown-1). Workaround seen: systemctl restart gdm.
Cause: Boot-order races between the display stack pieces; HS200 only made the userspace side start earlier than the panel and decon.
Evidence: docs/display-handover-plan-2026-10-30.md; boots 2026-10-30.
