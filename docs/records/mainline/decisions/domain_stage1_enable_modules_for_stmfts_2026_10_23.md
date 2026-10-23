id: domain_stage1_enable_modules_for_stmfts_2026_10_23
type: domain
area: mainline
perspective: user
created: 1792770177.215532
edges: [{"target_id": "domain_stmfts_fts1a096_variant_2026_10_23", "edge_type": "related"}, {"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_2026_10_23", "edge_type": "related"}, {"target_id": "learning_defconfig_modules_pinned_builtin_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_bt_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "related"}]
cue: You are about to iterate a driver (touch, audio, BT) on the SM-T585 and consider reflashing the boot image for every change.
---

Decision: Enable CONFIG_MODULES in the stage-1 kernel and build stmfts as a module, so drivers can be iterated via wget + rmmod/insmod without reflashing (user-approved 2026-10-23).
Why: Each flash cycle is slow, and touch/audio/BT need many iterations.
Scope: Stage-1 kernel config kernel/gtaxllte-stage1.config.
