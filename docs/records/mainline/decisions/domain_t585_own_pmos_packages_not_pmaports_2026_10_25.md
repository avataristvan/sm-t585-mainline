id: domain_t585_own_pmos_packages_not_pmaports_2026_10_25
type: domain
area: mainline
perspective: agent
created: 1792956341.366237
superseded_by: domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26
valid_until: 1792971074.080613
edges: [{"target_id": "learning_t585_pmos_kconfig_overrides_stage1_trims_image_size_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_dtbtool_needs_model_info_props_fdtput_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_sboot_ignores_cmdline_accepts_os_version_zero_2026_10_25", "edge_type": "related"}, {"target_id": "learning_pmbootstrap_build_src_rsync_skips_timeconst_bc_2026_10_25", "edge_type": "related"}]
cue: You want to build or install postmarketOS for the SM-T585 and wonder whether to use the existing pmaports Exynos 7 device packages.
---

Decision: The pmOS device and kernel are our own packages in this repo: pmos/device-samsung-gtaxllte and pmos/linux-samsung-gtaxllte. The kernel is built only from the working tree (pmbootstrap build linux-samsung-gtaxllte --src=<repo>/src/mainline). Both are symlinked into ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing. The pmaports device-samsung-exynos7 and linux-postmarketos-exynos7870 are not used.
Why: Those use a chainloaded systemd-boot/fastboot path, not S-Boot directly; the SM-T585 boots from S-Boot's BOOT partition.
Scope: deviceinfo of pmos/device-samsung-gtaxllte: S-Boot boot.img v0, page 2048, base 0x10000000, kernel 0x8000, ramdisk 0x1000000, tags 0x100, bootimg_qcdt_type exynos with platform 0x50a6 and subtype 0x217584da, append_seandroidenforce, initfs zstd. Related: learning_t585_pmos_kconfig_overrides_stage1_trims_image_size_2026_10_25, learning_t585_dtbtool_needs_model_info_props_fdtput_2026_10_25, learning_t585_sboot_ignores_cmdline_accepts_os_version_zero_2026_10_25, learning_pmbootstrap_build_src_rsync_skips_timeconst_bc_2026_10_25.
