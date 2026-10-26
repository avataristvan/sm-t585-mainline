id: learning_t585_pmos_edge_boots_verified_over_usb_ssh_2026_10_25
type: learning
area: device
perspective: agent
created: 1792956340.880366
superseded_by: learning_t585_pmos_edge_boots_via_uboot_systemd_boot_2026_10_26
valid_until: 1792971072.75918
edges: [{"target_id": "todo_t585_alsa_ucm_profile_for_pipewire_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_panfrost_probes_on_mainline_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_general_lean_tablet_not_music_only_2026_10_25", "edge_type": "related"}]
cue: You want to know whether the postmarketOS install on the SM-T585 really runs and what is still broken after its first boot.
---

Observed: postmarketOS edge (systemd) boots on the SM-T585 from our BOOT image with the userspace in Lineage's SYSTEM partition. Verified: ssh over USB (172.16.42.1); RAM idle 161 MB used of 1949 MB; root 3.0G (545 MB used); GPU device nodes present; sound card SM-T585 present. Only failed unit: nftables.service.
Cause (hypothesis, to verify): the kernel has no nftables support. The pmos config adds no nf_tables options; the stage-1 trims may be the reason. Check kernel/build/.config.
Evidence: device checks over ssh, 2026-10-25.
