id: domain_kernel_modules_allowed_where_sensible_2026_10_26
type: domain
area: mainline
perspective: user
created: 1792974305.404515
edges: [{"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "supersedes"}, {"target_id": "domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26", "edge_type": "derived_from"}, {"target_id": "learning_t585_wlan_enable_pulls_vendor_drivers_pmos_config_2026_10_26", "edge_type": "related"}]
cue: You are deciding whether a kernel option for the SM-T585 pmOS build should be =y, =m or dropped (e.g. WiFi, ath10k).
---

Decision: Kernel options may be built as modules (=m) wherever sensible. The earlier "no =m, drop instead" rule no longer holds. User: "modularisiere gern alles, was sinnvoll ist. früher habe ich nur die fs-sachen intern gehabt." WiFi (CFG80211, MAC80211, ATH10K, ATH10K_SDIO) goes in as =m first. Kept from the older policy: peripherals, networking, USB, audio and Bluetooth must run and are not cut; drivers of other SoCs/boards and hardware crypto of other SoCs stay dropped.
Why: The 32 MiB BOOT limit that motivated the no-=m rule is gone on the pmOS path (U-Boot -> systemd-boot loads the kernel from the FAT32 ESP; see domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26). Modules also load firmware after rootfs mount (ath10k) and allow rmmod/modprobe iteration.
Scope: Kernel config for the pmOS path (kernel/gtaxllte-pmos.config). Boot-critical drivers (eMMC, filesystems, whatever the initramfs needs before root) stay built-in unless the initramfs carries them. A broad modularization pass over existing =y options is not done yet (needs HW test). The stage-1 config (32 MiB BOOT) is unaffected.
