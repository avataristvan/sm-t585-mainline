id: learning_defconfig_modules_pinned_builtin_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792771107.398246
edges: [{"target_id": "domain_stage1_enable_modules_for_stmfts_2026_10_23", "edge_type": "derived_from"}, {"target_id": "domain_kernel_config_trim_policy_bt_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "related"}]
cue: You enable CONFIG_MODULES or change the kernel fragments and wonder why the image is big or drivers vanished; or build with merge_config.
---

Observed: While CONFIG_MODULES was off, merge_config + olddefconfig promoted all 382 arm64-defconfig =m options to =y, so the stage-1 Image (~19 MB) carries them. Enabling modules would turn them back into (unbuilt) modules and drop needed drivers. They were therefore pinned to =y in a new fragment kernel/gtaxllte-builtin.config (merged after gtaxllte-stage1.config), keeping the image identical except stmfts=m. The build command now needs three fragments: defconfig + gtaxllte-stage1.config + gtaxllte-builtin.config.
Cause: Without module support, olddefconfig resolves =m to =y. Most of the 382 are ballast for other SoCs: 44 DRM bridges/GPUs (Lima, PowerVR, Etnaviv ...), ~45 network/ethernet PHY/WLAN, 36 PHYs, foreign regulators (Qualcomm PM8008, MediaTek MT6315), battery/charger (MAX17042, SBS), 32 crypto. Worth keeping: DRM_PANFROST (Mali-T830 is Midgard), DRM_EXYNOS + DRM_SAMSUNG_DSIM (DSI panel later), PHY_EXYNOS5_USBDRD.
Evidence: kernel/gtaxllte-builtin.config, kernel/gtaxllte-stage1.config, session 2026-10-23.
