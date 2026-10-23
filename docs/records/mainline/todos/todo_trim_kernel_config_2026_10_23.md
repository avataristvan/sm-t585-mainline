id: todo_trim_kernel_config_2026_10_23
type: todo
area: mainline
perspective: agent
created: 1792771107.951043
edges: [{"target_id": "learning_defconfig_modules_pinned_builtin_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_rt5659_codec_probes_mainline_2026_10_23", "edge_type": "related"}]
cue: The touch bring-up is done and you look for the next cleanup, or the boot image gets close to the 32 MiB BOOT limit.
---

TODO: Trim the kernel config per domain_kernel_config_trim_policy_2026_10_23, after the touch bring-up; not urgent (13 MiB free in BOOT). Both the 382 pinned options (kernel/gtaxllte-builtin.config) and the ~1820 options already =y in arm64 defconfig contain ballast. Size gain not measured.
