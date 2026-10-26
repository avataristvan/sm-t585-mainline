id: pattern_t585_twrp_dtb_bisect_swap_in_pmos_boot_2026_10_27
type: pattern
area: workflow
perspective: agent
created: 1793043525.058969
edges: [{"target_id": "pattern_t585_recover_boot_via_twrp_stage1_image_2026_10_25", "edge_type": "related"}]
cue: A DTB change hangs pmOS on the T585 and you want to bisect by swapping the DTB from TWRP without a flash.
---

Rule: In TWRP, losetup -o $((2048*512)) on mmcblk0p23 and mount the vfat pmOS_boot; swap exynos7870-gtaxllte.dtb (keep a backup as .full) with an fdtput-edited copy (e.g. status=disabled on a node), reboot, repeat.
When: A DTB change hangs pmOS boot and the cause is a node, not the kernel.
Why: TWRP's 3.18 kernel cannot mount the ext4 pmOS_root (EINVAL), but vfat pmOS_boot mounts fine, which is all the DTB needs. In pmOS USERDATA the root partition starts at LBA 999424 (not 499712 as in the old SYSTEM install), so reuse of old offsets is wrong.
