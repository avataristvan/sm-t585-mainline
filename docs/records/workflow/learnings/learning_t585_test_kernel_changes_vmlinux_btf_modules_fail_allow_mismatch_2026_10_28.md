id: learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28
type: learning
area: workflow
perspective: agent
created: 1793226635.706294
edges: [{"target_id": "pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27", "edge_type": "related"}, {"target_id": "pattern_t585_crash_iteration_panic5_boot_entry_fb0_blank_pstore_2026_10_28", "edge_type": "related"}, {"target_id": "learning_t585_test_kernel_localversion_empty_reuse_package_modules_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_never_rmmod_charger_host_built_module_fails_btf_package_kernel_2026_10_29", "edge_type": "related"}]
cue: After swapping in a test kernel on the SM-T585 every module fails with "failed to validate module BTF -22", including the charger.
---

Observed: Test kernels with built-in driver changes, a struct change in samsung-dsim.h, or a full W=1 rebuild change the vmlinux BTF; every package module then fails with "failed to validate module BTF -22", including the charger. Passing W=1 to an Image build also recompiles the whole kernel.
Cause: Module BTF is validated against the running vmlinux BTF; the package modules were built against the other vmlinux.
Evidence: session 2026-10-28. Workaround: build test kernels in a separate build dir with CONFIG_MODULE_ALLOW_BTF_MISMATCH=y; restore with /boot/vmlinuz.good.
