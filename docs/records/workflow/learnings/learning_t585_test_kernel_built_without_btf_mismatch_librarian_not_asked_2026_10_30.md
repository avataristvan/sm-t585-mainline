id: learning_t585_test_kernel_built_without_btf_mismatch_librarian_not_asked_2026_10_30
type: learning
area: workflow
perspective: agent
created: 1793380728.784193
edges: [{"target_id": "learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28", "edge_type": "confirms"}, {"target_id": "learning_t585_test_kernel_localversion_empty_reuse_package_modules_2026_10_29", "edge_type": "confirms"}]
cue: About to build a hand-installed test kernel for the SM-T585 (kernel/build or a separate build dir).
---

Observed: The first D1/D2 test kernel was built in kernel/build without CONFIG_MODULE_ALLOW_BTF_MISMATCH. Every package module failed (BTF -22), so no panel and no GDM. kernel/build/.config was also stale (r12, cpuidle off) and had to be re-merged. The records already said so; the librarian was not asked before building the test kernel.
Cause: Agent skipped the librarian query at the start of a test-kernel build, so the two existing lessons were not recalled.
Evidence: learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28; learning_t585_test_kernel_localversion_empty_reuse_package_modules_2026_10_29; session 2026-10-30.
