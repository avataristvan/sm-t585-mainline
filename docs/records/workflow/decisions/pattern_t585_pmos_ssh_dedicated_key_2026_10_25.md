id: pattern_t585_pmos_ssh_dedicated_key_2026_10_25
type: pattern
area: workflow
perspective: agent
created: 1792956374.64624
edges: [{"target_id": "learning_pmos_home_dir_777_sshd_ignores_authorized_keys_2026_10_25", "edge_type": "related"}, {"target_id": "learning_host_ncm_iface_name_changes_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26", "edge_type": "related"}]
cue: You need to ssh into the postmarketOS install on the SM-T585 from a Claude session and wonder which key to use.
---

Rule: Reach pmOS with the dedicated, passphrase-less key ~/.ssh/id_ed25519_gtaxllte: ssh -i ~/.ssh/id_ed25519_gtaxllte -o IdentitiesOnly=yes istvan@172.16.42.1. The user's main key must not be used for this device.
When: an agent session needs ssh access to the SM-T585 running pmOS over USB.
Why: The main key is passphrase-protected, so an agent cannot use it non-interactively; the dedicated key has no passphrase.
