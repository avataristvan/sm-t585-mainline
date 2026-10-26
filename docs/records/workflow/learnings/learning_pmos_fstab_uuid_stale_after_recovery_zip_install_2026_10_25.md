id: learning_pmos_fstab_uuid_stale_after_recovery_zip_install_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792956373.22828
edges: [{"target_id": "pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26", "edge_type": "related"}]
cue: After installing postmarketOS into the Lineage SYSTEM partition, boot stalls for 90 s on /boot and sshd is missing.
---

Observed: The android-recovery-zip installer reformats the partitions, but /etc/fstab keeps the disk-image UUIDs. systemd waits 90 s for /boot, local-fs.target fails, the system drops to emergency mode and sshd does not start ("Timed out waiting for device /dev/disk/by-uuid/..."). Fixed with LABEL=pmOS_root and LABEL=pmOS_boot in /etc/fstab; the original is kept as /etc/fstab.uuid-orig.
Cause: The installer reformats without rewriting the UUIDs in fstab.
Evidence: the journal of the failed boot, read as in pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25; /etc/fstab.uuid-orig on the device.
