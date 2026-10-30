id: pattern_t585_dwmmc_diag_kernel_runtime_flags_via_acm_shell_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793375792.888193
edges: [{"target_id": "learning_t585_hs200_drto_samsung_extended_tmout_format_cause_2026_10_30", "edge_type": "related"}, {"target_id": "pattern_t585_runtime_switch_hypothesis_tests_one_diagnostic_kernel_2026_10_29", "edge_type": "confirms"}, {"target_id": "pattern_t585_pmos_no_root_use_initramfs_logs_and_acm_shell_2026_10_30", "edge_type": "related"}]
cue: A test kernel boots on the SM-T585 but cannot read its root storage and you need to bisect controller settings without reflashing each time.
---

Rule: Put the suspected controller settings behind a runtime module param in a diagnostic kernel (here dw_mmc.dbg_flags: bit0 force PIO, bit1 read threshold off, bit2 TMOUT max, bit3 threshold 256), boot it, let the root mount fail, and toggle the flags from the initramfs ACM debug shell. Log RINTSTS/IDSTS per failing transfer to tell timeout (DRTO) from CRC or DMA errors. Use the same boot to install the fix kernel without TWRP: with the knob the eMMC is readable, mount pmOS_boot via a loop device at offset 1 MiB on mmcblk0p23, and send the kernel over nc on the USB network.
When: A kernel boots but cannot read its root storage; several hypotheses about controller settings compete.
Why: It found the HS200 cause in one boot: only "TMOUT max" fixed the reads, which pointed at the timeout encoding, and the logging refuted the sampling-phase hypothesis. The debug patch is kept out of tree.
Evidence: docs/emmc-speed-plan-2026-10-30.md; learning_t585_hs200_drto_samsung_extended_tmout_format_cause_2026_10_30
