id: pattern_t585_pmos_post_install_checklist_2026_10_25
type: pattern
area: workflow
perspective: agent
created: 1792956689.321212
edges: [{"target_id": "learning_pmos_fstab_uuid_stale_after_recovery_zip_install_2026_10_25", "edge_type": "related"}, {"target_id": "learning_pmos_home_dir_777_sshd_ignores_authorized_keys_2026_10_25", "edge_type": "related"}]
cue: The recovery-zip install of postmarketOS on the SM-T585 is done and the first boot stalls or ssh key login fails.
---

Rule: After the recovery-zip install, before trusting the result: (1) in /etc/fstab, replace the disk-image UUIDs with LABEL=pmOS_root and LABEL=pmOS_boot (keep the original as /etc/fstab.uuid-orig); (2) chmod 755 ~ on /home/<user>, which the installer leaves at mode 777, so sshd reads authorized_keys.
When: right after pmbootstrap's recovery-zip install of pmOS on the SM-T585.
Why: The installer reformats the partitions but keeps the old fstab UUIDs and the home mode. The first stalls the boot for 90 s on /boot; the second blocks ssh key login. See learning_pmos_fstab_uuid_stale_after_recovery_zip_install_2026_10_25 and learning_pmos_home_dir_777_sshd_ignores_authorized_keys_2026_10_25.
