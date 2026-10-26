id: learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792876421.198081
edges: [{"target_id": "domain_t585_userspace_postmarketos_not_lineage_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_panfrost_probes_on_mainline_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_panfrost_mali_supply_opp_table_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sdl3_kmsdrm_pad_grid_multitouch_2026_10_25", "edge_type": "related"}]
cue: You want to test GPU rendering on the SM-T585 display before building a GUI, and wonder whether Mesa can drive simpledrm.
---

Observed: On the SM-T585 with the stage-1 image boot-stage1-k32b.img, `kmscube -D /dev/dri/card0` showed the spinning cube on the panel (user confirmed). Scanout went through the simpledrm card, rendering through Panfrost on /dev/dri/renderD128. Mesa reported "OpenGL ES 3.1 Mesa 26.1.6" and renderer "Mali-T830 MC1 (Panfrost)". dmesg showed no panfrost errors after 30 s.
Cause: not separated. Mesa has no simpledrm_dri.so, yet GBM/EGL on the simpledrm card worked and picked Panfrost for rendering. So the GPU path does not need a driver-specific display backend here.
Evidence: kmscube run on 2026-10-24 with boot-stage1-k32b.img; userspace from the Alpine rootfs (see learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24). This is the rendering test that learning_t585_panfrost_probes_on_mainline_2026_10_24 lacked.
