id: domain_t585_rootfs_image_in_lineage_userdata_2026_10_25
type: domain
area: goal
perspective: user
created: 1792923340.579202
superseded_by: domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25
valid_until: 1792956389.98272
edges: [{"target_id": "learning_t585_lineage_userdata_ext4_quota_needs_qfmt_v2_2026_10_25", "edge_type": "derived_from"}, {"target_id": "learning_t585_rootfs_image_made_on_device_no_usb_copy_2026_10_25", "edge_type": "derived_from"}, {"target_id": "domain_t585_userspace_postmarketos_not_lineage_2026_10_24", "edge_type": "supersedes"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25", "edge_type": "related"}]
cue: You want the Alpine rootfs on the SM-T585 without a working SD card, and wonder where it lives and what a boot without SD touches.
---

Decision: With no working SD card, the Alpine rootfs lives as an ext4 image file, /data/gtaxl/rootfs.ext4 (4 GiB, label gtaxl-data-root), in Lineage's userdata partition (mmcblk0p23, ext4, about 24.7 GB, 13.8 GB free before). Stage 1 stays PID 1 with its debug shells ("chroot under stage 1", not switch_root). kernel/initramfs/rootfs-up mounts the SD partition labelled gtaxl-root if present; else userdata plus the image (loop, rw); else, with an argument, a squashfs (ro, with tmpfs scratch dirs). It binds dev, pts, proc and sys and runs /etc/gtaxl/autostart in a chroot if it is executable. kernel/initramfs/rootsh enters it. init calls rootfs-up at boot, after polling up to 5 s for gtaxl-root. The SD-card step of Stage A in the superseded decision is replaced by this; an SD partition labelled gtaxl-root still takes precedence.
Why: Keeps the debug access safe (stage 1 and its shells stay in charge), needs no SD card, and removal is deleting one directory. The user's own idea, accepted by the user on 2026-10-25. The reasons of the superseded decision still hold: Lineage userspace is not viable on our mainline kernel, and the path is postmarketOS (Alpine).
Scope: kernel/initramfs/rootfs-up, rootsh and init. Consequence: every boot without an SD card mounts Lineage's userdata rw. The superseded decision called Lineage /data encrypted and unusable; learning_t585_lineage_userdata_ext4_quota_needs_qfmt_v2_2026_10_25 corrects that: the mount works and a directory we create is unencrypted and usable. Not verified: that Lineage tolerates the foreign /data/gtaxl at its next boot.
