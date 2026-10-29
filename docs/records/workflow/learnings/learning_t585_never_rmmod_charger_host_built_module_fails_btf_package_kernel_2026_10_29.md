id: learning_t585_never_rmmod_charger_host_built_module_fails_btf_package_kernel_2026_10_29
type: learning
area: workflow
perspective: agent
created: 1793311937.045837
edges: [{"target_id": "learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28", "edge_type": "confirms"}]
cue: You want to hot-load a rebuilt charger or fuel-gauge module on the running SM-T585 package kernel after rmmod.
---

Observed: Host-built modules (kernel/build) do not load into a pmbootstrap-built package kernel (BTF -22, different compiler). Loading failed after rmmod, leaving charger and fuel gauge unloaded for a minute.
Cause: BTF mismatch between the host build and the package kernel's vmlinux.
Instead: test such modules only on the build-diag kernel with CONFIG_MODULE_ALLOW_BTF_MISMATCH=y, and never rmmod the charger before the replacement is known to load.
Evidence: session 2026-10-29; confirms learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28.
