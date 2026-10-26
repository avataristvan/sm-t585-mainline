id: domain_t585_pmos_in_userdata_pmaports_model_2026_10_26
type: domain
area: goal
perspective: user
created: 1792971070.758791
edges: [{"target_id": "learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_uboot_blkmap_root_picks_largest_partition_userdata_2026_10_25", "edge_type": "derived_from"}, {"target_id": "domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26", "edge_type": "related"}, {"target_id": "domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25", "edge_type": "supersedes"}, {"target_id": "pattern_t585_pmos_install_via_recovery_zip_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_pmos_ui_gnome_mobile_2026_10_26", "edge_type": "related"}]
cue: You want to know which partition holds postmarketOS on the SM-T585, or you plan to flash or wipe USERDATA or SYSTEM.
---

Decision (user, 2026-10-25): postmarketOS moves from SYSTEM (mmcblk0p19) to USERDATA (mmcblk0p23), following the upstream pmaports Exynos 7870 model (device-samsung-exynos7): the pmOS disk image goes into USERDATA, U-Boot (in BOOT) boots it. It replaces the install-location part of domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25.
Why: U-Boot's blkmap picks USERDATA as root anyway (learning_t585_uboot_blkmap_root_picks_largest_partition_userdata_2026_10_25), so no U-Boot patch is needed, and USERDATA gives 26 GB instead of SYSTEM's 3.3 GB.
Accepted cost: USERDATA is wiped: the Lineage data, the stage-1 Alpine rootfs (/data/gtaxl) and /sdcard/boot-lineage.img. The Lineage boot image backup is on the host in device-dump/sm-t585/partitions/boot.img.
Scope: The SM-T585 install layout. Result as observed: learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26. Package side: domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26. The recovery-zip install pattern (pattern_t585_pmos_install_via_recovery_zip_2026_10_25) targets SYSTEM and is outdated by this.
