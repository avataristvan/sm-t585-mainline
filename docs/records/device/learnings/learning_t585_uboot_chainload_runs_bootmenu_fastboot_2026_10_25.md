id: learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25
type: learning
area: device
perspective: agent
created: 1792963730.740706
edges: [{"target_id": "learning_t585_dtbtool_needs_model_info_props_fdtput_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_uboot_env_bootmenu_timeout_power_off_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_uboot_fastboot_entry_vol_down_bootmenu_2026_10_26", "edge_type": "related"}, {"target_id": "todo_t585_uboot_hang_after_no_ethernet_2026_10_26", "edge_type": "related"}]
cue: You want a bootloader with fastboot and a boot menu on the SM-T585, or wonder how mainline U-Boot gets started on it.
---

Observed: Mainline U-Boot (exynos-mobile_defconfig, commit 8649a54d) chainloaded by S-Boot runs on the SM-T585 (verified on hardware, 2026-10-25). The bootmenu shows on the simplefb framebuffer (1200x1920), the buttons work, and fastboot over USB works (`fastboot getvar all`: product samsung-gtaxllte, platform exynos7870, max-download-size 0x07000000). Env is ENV_IS_NOWHERE (no saveenv).
Cause: Build by uboot/build.sh: our board DTS subset uboot/dts/exynos7870-gtaxllte.dts plus a -u-boot.dtsi (model_info props, framebuffer, memory banks), symlinked into src/u-boot. Packed with kernel/mkbootimg-gtaxllte.py (DTBH, empty ramdisk), DTB padded with dtc -p 16384. Image about 745 KB, flashed to BOOT like any boot image.
Evidence: hardware test 2026-10-25; uboot/build.sh; related learning_t585_dtbtool_needs_model_info_props_fdtput_2026_10_25.
