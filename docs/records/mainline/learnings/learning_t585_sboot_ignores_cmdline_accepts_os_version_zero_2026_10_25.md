id: learning_t585_sboot_ignores_cmdline_accepts_os_version_zero_2026_10_25
type: learning
area: mainline
perspective: agent
created: 1792956350.114337
edges: [{"target_id": "pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_pstore_needs_printk8_in_init_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26", "edge_type": "related"}]
cue: Your pmOS boot image does not start, or you wonder why the kernel command line does not reach the SM-T585 kernel and root is still found.
---

Observed: S-Boot accepted the pmOS boot.img with os_version=0 (our stage-1 image copies 0x1c00018b; that is not needed). S-Boot drops the kernel command line, so pmos_boot_uuid never reaches the kernel. The pmOS initramfs still found the root inside SYSTEM, by subpartitions and labels.
Cause: S-Boot replaces the kernel command line entirely.
Evidence: pmOS boot on hardware, 2026-10-25 (boot log via pstore, see pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25).
