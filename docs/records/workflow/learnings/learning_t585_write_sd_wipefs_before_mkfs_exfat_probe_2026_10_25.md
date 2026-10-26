id: learning_t585_write_sd_wipefs_before_mkfs_exfat_probe_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792917935.725137
edges: [{"target_id": "learning_t585_worn_sd_card_discards_writes_reread_size_check_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}]
cue: You are about to format a reused SD card as ext4 and then unpack a rootfs into it, and the card held exFAT before.
---

Observed: On the first run of kernel/tools/rootfs/write-sd.sh, unsquashfs failed on symlinks ("failed to create symlink ... Operation not permitted") after mkfs.ext4 had made the 16 GiB partition. The partition still began with the old exFAT boot sector, and a plain mount auto-detected exfat. The script now runs wipefs -a on the new partition before mkfs.ext4 and mounts with -t ext4.
Cause: mkfs.ext4 leaves the first 1 KiB of the partition untouched, so an old FAT or exFAT boot sector survives and a plain mount picks that type instead of ext4.
Evidence: kernel/tools/rootfs/write-sd.sh (lines 40-44, the wipefs and mount -t ext4 fix); first run 2026-10-25, the unsquashfs error is in the terminal output of that run.
