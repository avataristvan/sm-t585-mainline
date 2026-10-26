id: learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26
type: learning
area: device
perspective: agent
created: 1792971054.185625
edges: [{"target_id": "domain_t585_pmos_in_userdata_pmaports_model_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_pmos_edge_boots_verified_over_usb_ssh_2026_10_25", "edge_type": "supersedes"}, {"target_id": "learning_pmos_fstab_uuid_stale_after_recovery_zip_install_2026_10_25", "edge_type": "related"}, {"target_id": "learning_pmos_home_dir_777_sshd_ignores_authorized_keys_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_pmos_ssh_dedicated_key_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_panel_power_test_variant_dtb_plus_second_boot_entry_2026_10_27", "edge_type": "related"}]
cue: You want to know how pmOS boots on the SM-T585 now (U-Boot, systemd-boot, EFI), how fast, and what still fails after boot.
---

Observed: Verified on hardware 2026-10-26: pmOS edge boots via S-Boot -> U-Boot (in BOOT) -> bootefi bootmgr -> systemd-boot on the FAT32 pmOS_boot -> our 7.3 kernel (EFI stub). Ready over USB about 16 s after reboot. Root (loop0p2 inside the blkmap'd USERDATA) auto-grew to 24.8 GB; /boot is 487 MB FAT32. The cmdline now comes from pmOS (pmos_boot_uuid, pmos_root_uuid, initcall_blacklist=efifb_driver_init); S-Boot's cmdline override no longer matters. /sys/firmware/efi is present. Idle RAM 118 MB used. Only failed unit still: nftables.service (cause still the unverified hypothesis of missing nf_tables options).
The UUID fstab and home-777 fixes needed after the recovery-zip install were not needed with an image flashed by `pmbootstrap flasher flash_rootfs` (fastboot -> userdata). The ssh key was put in by `pmbootstrap config ssh_keys True` plus `ssh_key_glob ~/.ssh/id_ed25519_gtaxllte.pub`.
Cause: The move to USERDATA with the upstream-style EFI boot path (domain_t585_pmos_in_userdata_pmaports_model_2026_10_26); flash_rootfs writes a proper disk image, unlike the recovery zip installer.
Evidence: hardware test and ssh checks 2026-10-26. Supersedes the S-Boot-direct, SYSTEM-partition observation in learning_t585_pmos_edge_boots_verified_over_usb_ssh_2026_10_25.
