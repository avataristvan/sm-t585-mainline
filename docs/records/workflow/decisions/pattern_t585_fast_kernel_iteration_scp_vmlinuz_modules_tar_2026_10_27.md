id: pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27
type: pattern
area: workflow
perspective: agent
created: 1793045943.545259
edges: [{"target_id": "learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27", "edge_type": "related"}, {"target_id": "pattern_t585_recover_boot_via_twrp_stage1_image_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_crash_iteration_panic5_boot_entry_fb0_blank_pstore_2026_10_28", "edge_type": "related"}, {"target_id": "learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28", "edge_type": "related"}, {"target_id": "learning_t585_test_kernel_localversion_empty_reuse_package_modules_2026_10_29", "edge_type": "related"}]
cue: You want to test a freshly built mainline kernel on the SM-T585 pmOS without a pmbootstrap build and flash.
---

Rule: Build on the host, run `make modules_install INSTALL_MOD_PATH=<dir>` and tar it. scp vmlinuz and the tar to the tablet, untar to / with root on the tablet (see CLAUDE.local.md), back up /boot/vmlinuz as vmlinuz.good, then copy the new Image to /boot/vmlinuz. Recovery: copy vmlinuz.good back (via ssh, or a TWRP vfat mount of pmOS_boot).
When: Iterating kernel or driver changes on the running pmOS (e.g. the DSI hang); not for producing the final package.
Why: Skips the pmbootstrap build and flash round-trip. The dirty tree gives release 7.3.0-gtaxllte+, so its modules dir does not clobber the package's 7.3.0-gtaxllte.
