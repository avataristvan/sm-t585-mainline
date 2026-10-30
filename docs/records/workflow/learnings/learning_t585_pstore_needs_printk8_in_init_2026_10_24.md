id: learning_t585_pstore_needs_printk8_in_init_2026_10_24
type: learning
area: workflow
perspective: the-coder
created: 1792848643.190558
edges: [{"target_id": "pattern_debug_stage1_hangs_memtool_udplog_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_up_echo_fatal_no_stdout_at_stage1_boot_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_stage1_background_script_no_stdout_set_e_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_sboot_ignores_cmdline_accepts_os_version_zero_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_hang_without_panic_leaves_pstore_empty_2026_10_30", "edge_type": "related"}]
cue: A boot hang or crash left nothing useful in pstore, or you are reading the mainline pstore after a failed boot.
---

Observed: S-Boot passes loglevel=4, so console-ramoops only recorded warnings; a silent hang left nothing useful in pstore. kernel/initramfs/init now sets `echo 8 > /proc/sys/kernel/printk` right after mounting pstore, so everything after init reaches pstore. TWRP's /proc/last_kmsg holds only the S-Boot log and TWRP shows no mainline pstore; read the mainline pstore by booting a known-good mainline image (kernel/out/boot-stage1-k10.img). TWRP's dd needs bs=1048576 (no "1M" suffix).
Cause: S-Boot replaces the cmdline (loglevel=4); TWRP does not mount mainline pstore.
Evidence: kernel/initramfs/init; thermal chunk 1 session 2026-10-24 (kernel #15/#16 hangs).
