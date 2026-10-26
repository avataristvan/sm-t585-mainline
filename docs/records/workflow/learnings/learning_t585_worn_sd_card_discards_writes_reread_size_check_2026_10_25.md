id: learning_t585_worn_sd_card_discards_writes_reread_size_check_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792917936.010969
edges: [{"target_id": "learning_t585_write_sd_wipefs_before_mkfs_exfat_probe_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}]
cue: You are writing a new partition table to an SD card and need to know whether the kernel really took it after the reread.
---

Observed: On the first run of write-sd.sh, a worn 64 GB SanDisk card (SU64G) silently discarded writes. sfdisk reported the new 16 GiB table, but after blockdev --rereadpt the kernel read the old 59.5 GiB exFAT table again. The host log showed "exFAT-fs: Volume was not properly unmounted" on every mount, and the card first enumerated "(ro)". The script now compares the partition size after the reread with 16 GiB and aborts on a mismatch.
Cause: A worn SD card can silently discard writes, so sfdisk's success does not prove the table was written. Only the kernel's view after the reread shows it.
Evidence: kernel/tools/rootfs/write-sd.sh (lines 37-39, the size check); first run 2026-10-25 (host kernel log, not kept under docs/sources).
