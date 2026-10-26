id: learning_t585_sdl3_kmsdrm_pad_grid_multitouch_2026_10_25
type: learning
area: workflow
perspective: the-coder
created: 1792925767.721054
edges: [{"target_id": "learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24", "edge_type": "confirms"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_general_lean_tablet_not_music_only_2026_10_25", "edge_type": "related"}]
cue: You want a GUI on the SM-T585 display with no compositor, and wonder whether SDL3 can drive KMS with GPU rendering and multitouch.
---

Observed: On the SM-T585 (mainline stage 1, Alpine rootfs), apps/pads/pads.c, an SDL3 (3.4.10, Alpine) 4x4 pad grid, runs straight on KMS without a compositor. It was compiled on the device in the rootfs with build-base and sdl3-dev, which were installed by hand; build.sh ships only the runtime packages sdl3 and eudev-libs, so the dev packages survive only in the persistent ext4 image. SDL picks video "kmsdrm" on /dev/dri/card0 (simpledrm, atomic) and renderer "opengl" (Mesa/Panfrost). Multitouch from stmfts works: 4 fingers at once were seen and all 16 pads fire on and off.
Cause: not analysed; it works as observed. The GL path is the one kmscube already used. Whether scanout through simpledrm copies buffers (pad latency) is open.
Evidence: apps/pads/pads.c; kernel/tools/rootfs/build.sh (sdl3 and eudev-libs in PACKAGES); session on the device 2026-10-25; learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24 for the GPU path.
