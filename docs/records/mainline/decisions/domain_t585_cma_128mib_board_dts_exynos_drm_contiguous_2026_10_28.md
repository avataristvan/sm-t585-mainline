id: domain_t585_cma_128mib_board_dts_exynos_drm_contiguous_2026_10_28
type: domain
area: mainline
perspective: agent
created: 1793226617.528517
edges: [{"target_id": "domain_t585_pmos_ui_gnome_mobile_2026_10_26", "edge_type": "related"}]
cue: gnome-shell or GDM fails to log in on the SM-T585 with DRM_IOCTL_MODE_CREATE_DUMB ENOMEM, or you size CMA for exynos-drm.
---

Decision: The board DTS gets a linux,cma shared-dma-pool of 128 MiB (reusable, linux,cma-default) in reserved-memory (src/mainline commit 66eb17759).
Why: Without the SysMMU, exynos-drm allocates contiguous buffers. The default 32 MiB CMA made gnome-shell's DRM_IOCTL_MODE_CREATE_DUMB fail with ENOMEM, so login was impossible. It lives in the board DTS because the pool is board policy (not the SoC dtsi), and not on the cmdline because S-Boot replaces the cmdline entirely.
Scope: SM-T585 board DTS exynos7870-gtaxllte.dts; revisit if the SysMMU for DECON/DSIM is enabled.
