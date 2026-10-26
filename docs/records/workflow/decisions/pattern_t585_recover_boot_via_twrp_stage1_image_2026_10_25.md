id: pattern_t585_recover_boot_via_twrp_stage1_image_2026_10_25
type: pattern
area: workflow
perspective: agent
created: 1792956374.410296
edges: [{"target_id": "domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_twrp_usb_missing_after_uboot_hang_empty_battery_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_twrp_dtb_bisect_swap_in_pmos_boot_2026_10_27", "edge_type": "related"}, {"target_id": "pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27", "edge_type": "related"}]
cue: The SM-T585 no longer boots from BOOT and you need to get back to stage 1 with TWRP and a known boot image.
---

Rule: Recover with TWRP: Power + Vol-down, then Vol-up + Home + Power to enter TWRP. adb push kernel/out/boot-stage1-k33b.img and write it to BOOT (/dev/block/mmcblk0p9) with dd. In TWRP's dd use a numeric block size (bs=1048576).
When: BOOT holds a pmOS or other boot image that does not start.
Why: Only BOOT is written, so TWRP and the other partitions stay untouched; stage 1 gives a shell when pmOS does not boot. TWRP's dd needs the numeric bs.
