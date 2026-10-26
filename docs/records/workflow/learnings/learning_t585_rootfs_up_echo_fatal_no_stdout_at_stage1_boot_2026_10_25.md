id: learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25
type: learning
area: workflow
perspective: the-coder
created: 1792925768.256029
edges: [{"target_id": "domain_t585_rootfs_image_in_lineage_userdata_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_image_made_on_device_no_usb_copy_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_pstore_needs_printk8_in_init_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sdl3_kmsdrm_pad_grid_multitouch_2026_10_25", "edge_type": "related"}]
cue: After a stage-1 boot the rootfs chroot has no /dev/dri and rootfs-up stopped after mounting the image, with no error on screen.
---

Observed: At boot stage-1 init has no stdout ("Warning: unable to open an initial console"). rootfs-up's plain echo in log() failed, and set -e ended the script after mounting the rootfs image but before the dev, pts, proc and sys bind mounts. Init then printed "[stage1] no rootfs". Inside the chroot there was no /dev/dri ("openat /dev/dri/ ENOENT"), so SDL reported "kmsdrm not available".
Cause: the stdout echo in rootfs-up's log() was fatal under set -eu, and rootfs-up was started with no console.
Fix: in kernel/initramfs/rootfs-up the stdout echo in log() is non-fatal (the stderr copy to /dev/kmsg stays); in kernel/initramfs/init rootfs-up runs as `rootfs-up </dev/null >/dev/null 2>/dev/kmsg`. Built into kernel/out/boot-stage1-k33d.img; not yet flashed as of 2026-10-25.
Evidence: kernel/initramfs/rootfs-up (log()); kernel/initramfs/init (rootfs-up call); kernel/out/boot-stage1-k33d.img; the device session 2026-10-25. General rule: pattern_stage1_background_script_no_stdout_set_e_2026_10_25.
