id: learning_t585_sdl3_kmsdrm_segfault_without_libudev_2026_10_25
type: learning
area: workflow
perspective: the-coder
created: 1792925768.015078
edges: [{"target_id": "learning_t585_sdl3_kmsdrm_pad_grid_multitouch_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}]
cue: Your SDL3 app segfaults on the SM-T585 as kmsdrm starts, inside the VT switch callback, and the rootfs has no libudev.
---

Observed: Without libudev (package eudev-libs) SDL3's kmsdrm init segfaults in SDL_EVDEV_SetVTSwitchCallbacks (src/core/linux/SDL_evdev.c:294). With eudev-libs installed (udevd not running) input works.
Cause: the evdev init fails without libudev, and the evdev state is then NULL when the VT switch callbacks are set.
Evidence: kernel/tools/rootfs/build.sh (eudev-libs in PACKAGES, next to sdl3); apps/pads/pads.c; session on the device 2026-10-25. Sibling: learning_t585_sdl3_kmsdrm_pad_grid_multitouch_2026_10_25.
