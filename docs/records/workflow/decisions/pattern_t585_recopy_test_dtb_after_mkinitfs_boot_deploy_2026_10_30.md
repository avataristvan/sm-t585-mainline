id: pattern_t585_recopy_test_dtb_after_mkinitfs_boot_deploy_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793380728.535034
edges: [{"target_id": "learning_t585_panel_module_in_initramfs_fixes_black_screen_h1_h2_prepared_2026_10_30", "edge_type": "related"}]
cue: Hand-testing a kernel or DTB on the pmOS tablet and about to run mkinitfs or anything that rebuilds the initramfs.
---

Rule: After running mkinitfs on the tablet in a test setup, re-copy the hand-installed test DTB to /boot/exynos7870-gtaxllte.dtb.
When: Hand-testing kernels/DTBs on the pmOS tablet and touching the initramfs.
Why: mkinitfs triggers boot-deploy, which reinstalls the package DTB to /boot/exynos7870-gtaxllte.dtb and silently replaced a hand-installed test DTB (vmlinuz was left alone). Found during the display handover H1 work, 2026-10-30.
