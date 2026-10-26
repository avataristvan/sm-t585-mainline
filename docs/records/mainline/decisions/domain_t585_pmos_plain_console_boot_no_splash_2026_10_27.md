id: domain_t585_pmos_plain_console_boot_no_splash_2026_10_27
type: domain
area: mainline
perspective: user
created: 1793043525.290838
edges: [{"target_id": "domain_t585_pmos_packages_follow_exynos7_efi_model_2026_10_26", "edge_type": "related"}]
cue: You change the pmOS kernel cmdline of the T585 or wonder why the boot shows text instead of the plymouth logo.
---

Decision (user, 2026-10-27): The T585 shows plain console text at boot instead of the plymouth logo. pmos/device-samsung-gtaxllte/kernel-cmdline.conf removes quiet and splash (-quiet, -splash); pkgver 5 pkgrel 2, not yet installed.
Why: User preference (no further reason given).
Scope: device-samsung-gtaxllte cmdline only.
