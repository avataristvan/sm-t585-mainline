id: learning_t585_pmos_kconfig_overrides_stage1_trims_image_size_2026_10_25
type: learning
area: mainline
perspective: agent
created: 1792956349.653642
edges: [{"target_id": "domain_kernel_trim_chunk3_defconfig_ballast_off_2026_10_24", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_wlan_enable_pulls_vendor_drivers_pmos_config_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_backlight_class_pulls_defconfig_panel_modules_off_in_pmos_config_2026_10_26", "edge_type": "related"}]
cue: Your pmOS kernel config fails kconfigcheck, or the pmOS boot image no longer fits BOOT after the stage-1 config trimmed options.
---

Observed: kernel/gtaxllte-pmos.config adds what pmaports kconfigcheck wants ("default" and "zram" sets): DM_CRYPT, PSI, SECURITY, BPF_SYSCALL, BPF_EVENTS, BPF_LSM, DEBUG_KERNEL with DWARF5 and BTF (without DEBUG_INFO_REDUCED), FTRACE, KPROBES, module and firmware zstd compression, ZRAM backends. It must override the size trims in kernel/gtaxllte-stage1.config (BPF_SYSCALL, DEBUG_KERNEL, DEBUG_INFO_NONE). Cost: Image 13.5 -> 21.8 MB (.BTF alone 4.2 MB). The pmOS boot.img is 33,427,472 bytes against BOOT 33,554,432: 127 KB headroom (the systemd initramfs is 11.5 MB, already zstd). kernel/build-stage1.sh now strips module debug info (llvm-strip --strip-debug). BTF is the first candidate to drop if BOOT runs out.
Cause: pmaports kconfigcheck requires those options; the stage-1 size trims had removed them.
Evidence: kernel/gtaxllte-pmos.config; pmos/linux-samsung-gtaxllte/APKBUILD. The kconfigcheck.toml checker was an ad hoc script in the scratchpad, not in the repo.
