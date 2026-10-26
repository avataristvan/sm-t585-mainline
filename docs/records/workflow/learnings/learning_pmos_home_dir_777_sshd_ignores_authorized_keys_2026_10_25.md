id: learning_pmos_home_dir_777_sshd_ignores_authorized_keys_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792956373.468741
edges: [{"target_id": "pattern_t585_pmos_ssh_dedicated_key_2026_10_25", "edge_type": "related"}, {"target_id": "learning_pmos_fstab_uuid_stale_after_recovery_zip_install_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26", "edge_type": "related"}]
cue: Key login to postmarketOS on the SM-T585 fails, or its authorized_keys file seems to be ignored.
---

Observed: The android-recovery-zip installer creates /home/<user> with mode 777, so sshd ignores ~/.ssh/authorized_keys. chmod 755 ~ fixes it.
Cause: sshd refuses keys when the home directory is group- or world-writable (inferred from the symptom; not checked in the log).
Evidence: ssh over USB working after the chmod, 2026-10-25.
