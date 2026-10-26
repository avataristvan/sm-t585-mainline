id: domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25
type: domain
area: goal
perspective: agent
created: 1792956341.126983
superseded_by: domain_t585_pmos_in_userdata_pmaports_model_2026_10_26
valid_until: 1792971072.083994
edges: [{"target_id": "learning_t585_pmos_edge_boots_verified_over_usb_ssh_2026_10_25", "edge_type": "derived_from"}, {"target_id": "domain_t585_rootfs_image_in_lineage_userdata_2026_10_25", "edge_type": "supersedes"}, {"target_id": "domain_t585_systemd_over_openrc_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_pmos_ui_console_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_own_pmos_packages_not_pmaports_2026_10_25", "edge_type": "related"}, {"target_id": "learning_pmos_fstab_uuid_stale_after_recovery_zip_install_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_recover_boot_via_twrp_stage1_image_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_userspace_postmarketos_not_lineage_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_t585_pmos_install_via_recovery_zip_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_uboot_blkmap_root_picks_largest_partition_userdata_2026_10_25", "edge_type": "related"}]
cue: You want a full Linux userspace on the SM-T585 and wonder where postmarketOS lives, what boots it, and what Lineage still has.
---

Decision: The SM-T585 userspace is postmarketOS edge (systemd), installed into Lineage's SYSTEM partition (mmcblk0p19, 3.3 GiB). BOOT (mmcblk0p9) is written by hand with dd. It replaces the Alpine rootfs image in userdata. Lineage is broken until its zip (the lineageOS/ folder) is reflashed. The install left USERDATA untouched; whether the 4 GiB /data/gtaxl/rootfs.ext4 of the superseded decision is still there was not checked.
Why: Lineage's userspace relies on vendor HALs that expect the downstream kernel (Mali blob gralloc and HWC, Samsung audio HAL, sensors, RIL), so running it on mainline would be a new AOSP port (domain_t585_userspace_postmarketos_not_lineage_2026_10_24). The Alpine rootfs image was a stage-1 chroot, not a full distro (domain_t585_rootfs_image_in_lineage_userdata_2026_10_25). With no working SD card the install goes to SYSTEM; the session gives no further reason for SYSTEM.
Scope: The SM-T585 device. Install steps: pattern_t585_pmos_install_via_recovery_zip_2026_10_25. Packages: domain_t585_own_pmos_packages_not_pmaports_2026_10_25 (realizes Stage B of domain_t585_userspace_postmarketos_not_lineage_2026_10_24). Result as observed: learning_t585_pmos_edge_boots_verified_over_usb_ssh_2026_10_25.
