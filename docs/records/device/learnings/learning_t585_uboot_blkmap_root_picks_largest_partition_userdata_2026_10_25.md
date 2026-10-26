id: learning_t585_uboot_blkmap_root_picks_largest_partition_userdata_2026_10_25
type: learning
area: device
perspective: agent
created: 1792963731.152062
edges: [{"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_pmos_in_userdata_pmaports_model_2026_10_26", "edge_type": "related"}]
cue: You want U-Boot on the SM-T585 to boot the pmOS install and wonder which partition it looks in.
---

Observed: The exynos-mobile board code (exynos_blk_env_setup) picks the blkmap "root" partition with a buggy comparison (`info.start > largest_part_size`). On this GPT that ends at the last partition, USERDATA (mmcblk0p23, start 8013824, 53043200 sectors), not SYSTEM where pmOS currently lives (p19, start 507904, 6963200 sectors). The upstream model (pmaports device-samsung-exynos7: deviceinfo_boot_filesystem="fat32", systemd-boot, flash_method fastboot) expects the pmOS disk image in that largest partition; U-Boot then does `bootefi bootmgr`.
Cause: Comparison bug in exynos_blk_env_setup; env is ENV_IS_NOWHERE, so it cannot be overridden by saveenv.
Evidence: U-Boot source (exynos-mobile board code, commit 8649a54d), GPT of the device; domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25 for the current layout.
