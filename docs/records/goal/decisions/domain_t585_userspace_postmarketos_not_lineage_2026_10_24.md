id: domain_t585_userspace_postmarketos_not_lineage_2026_10_24
type: domain
area: goal
perspective: agent
created: 1792875788.489299
superseded_by: domain_t585_rootfs_image_in_lineage_userdata_2026_10_25
valid_until: 1792923352.382165
edges: [{"target_id": "learning_t585_panfrost_probes_on_mainline_2026_10_24", "edge_type": "related"}, {"target_id": "domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "todo_t585_alsa_ucm_profile_for_pipewire_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25", "edge_type": "related"}]
cue: You plan the SM-T585 userspace and wonder whether to run the installed LineageOS on the mainline kernel or move to postmarketOS.
---

Decision: The SM-T585 userspace is not LineageOS on our mainline kernel. The path is postmarketOS (Alpine).
Stage A: a rootfs on a microSD card, with the stage-1 init doing switch_root when it finds one (open: not built yet). First step done 2026-10-24: a RAM test, the Alpine rootfs as squashfs wgetted into /tmp and chrooted (learning_t585_rootfs_alpine_chroot_tmpfs_squashfs_2026_10_24); kmscube rendered on Panfrost from it (learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24). Only BOOT is written, so Lineage on eMMC stays untouched; Lineage /data is encrypted and unusable.
Stage B: a proper pmOS device package samsung-gtaxllte with our kernel fork, installed with pmbootstrap install --sdcard. Open assumption: pmOS support for the Exynos DTBH container is not verified yet.
Why: LineageOS userspace relies on vendor HALs that expect the downstream kernel: Mali blob gralloc and HWC, the Samsung audio HAL, sensors, RIL. Running it on mainline would be a new AOSP device port. LineageOS 21 is too heavy for 2 GB RAM. The user needs a GUI anyway, so Panfrost is wanted (learning_t585_panfrost_probes_on_mainline_2026_10_24).
Scope: Project direction for the SM-T585 (galaxy-tab-a-2016). Accepted by the user on 2026-10-24: "ja" to proceeding with the Alpine rootfs path (RAM test first, SD and switch_root next). Replaces the FOCUS item "evaluate LineageOS userspace" (state, not a record). The fallback in domain_t585_lean_linux_music_device_2026_10_23 is unchanged.
