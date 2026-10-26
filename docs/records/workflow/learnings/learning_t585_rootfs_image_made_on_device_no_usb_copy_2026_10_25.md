id: learning_t585_rootfs_image_made_on_device_no_usb_copy_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792923331.189527
edges: [{"target_id": "learning_t585_lineage_userdata_ext4_quota_needs_qfmt_v2_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_pmic_2key_reset_verified_on_hw_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_internet_via_ncm_host_nat_forward_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25", "edge_type": "related"}]
cue: You want a rootfs image on the tablet own storage without copying 4 GB over USB, and fear that a hard reset will damage it.
---

Observed: The 4 GiB rootfs image was created on the device itself, so nothing crossed USB: truncate the file, mkfs.ext4 it from the squashfs rootfs inside a chroot (e2fsprogs added to the PACKAGES of kernel/tools/rootfs/build.sh), loop-mount it rw, and cp -a from the squashfs. Verified: rootfs-up mounts it at boot (about 8 s); a file written in the chroot persists across a reboot; kmscube renders from it. The 2-key reset (learning_t585_pmic_2key_reset_verified_on_hw_2026_10_24) is a hard cut without sync, so ext4 reports "recovery complete" on loop0 at the next mount. The pwrkeyd 2 s hold syncs first.
Cause: the 2-key reset cuts power without a sync, so the ext4 journal is replayed on the next mount. The pwrkeyd long press syncs before its reboot, so it avoids that.
Evidence: kernel/tools/rootfs/build.sh (e2fsprogs in PACKAGES); kernel/initramfs/rootfs-up; the loop0 recovery message on the device, 2026-10-25 (terminal output, not kept under docs/sources); learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24.
