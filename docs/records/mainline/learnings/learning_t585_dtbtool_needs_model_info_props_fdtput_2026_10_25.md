id: learning_t585_dtbtool_needs_model_info_props_fdtput_2026_10_25
type: learning
area: mainline
perspective: agent
created: 1792956361.243102
edges: [{"target_id": "learning_t585_dtbs_check_clean_local_bindings_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26", "edge_type": "related"}]
cue: Your pmOS boot image is rejected or gets a wrong DTB chip or hardware revision, because dtbtool-exynos reads DT properties we lack.
---

Observed: dtbtool-exynos takes chip and hw_rev from the DT properties model_info-chip, model_info-hw_rev and model_info-hw_rev_end, which the mainline DTS lacks. The kernel APKBUILD sets them with fdtput on the installed dtb (7870, 0, 255), so dtbs_check stays clean. It then pads the dtb with dtc -p 16384, as kernel/build-stage1.sh does, for room for S-Boot's bootargs and memory.
Cause: The mainline board DTS has no model_info properties.
Evidence: pmos/linux-samsung-gtaxllte/APKBUILD; learning_t585_dtbs_check_clean_local_bindings_2026_10_24.
