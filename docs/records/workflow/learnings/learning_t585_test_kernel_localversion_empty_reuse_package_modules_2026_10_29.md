id: learning_t585_test_kernel_localversion_empty_reuse_package_modules_2026_10_29
type: learning
area: workflow
perspective: agent
created: 1793229150.824412
edges: [{"target_id": "pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28", "edge_type": "related"}, {"target_id": "learning_t585_test_kernel_built_without_btf_mismatch_librarian_not_asked_2026_10_30", "edge_type": "related"}]
cue: You built a test kernel for the SM-T585 from the dirty tree and its release ends in "+", so no modules dir matches on the tablet.
---

Observed: A test kernel built in a separate build dir (kernel/build-diag, copy of the package .config + CONFIG_MODULE_ALLOW_BTF_MISMATCH=y) from the dirty src/mainline tree gets release 7.3.0-gtaxllte+ (setlocalversion appends "+" when LOCALVERSION_AUTO is off and LOCALVERSION is unset in the environment). The installed package kernel is 7.3.0-gtaxllte, so the test kernel finds no /lib/modules dir (panel, WiFi etc. are modules).
Cause: setlocalversion adds "+" for a dirty tree. Fix: pass `LOCALVERSION=` on the make command line (`make ... LOCALVERSION= Image`); the release becomes 7.3.0-gtaxllte and the package modules load (BTF mismatch allowed, no MODVERSIONS). Check with `strings Image | grep "Linux version"` before copying.
Rule of thumb: for built-in-only test changes, reuse the package modules via LOCALVERSION=; for module changes, use the "+" route with own modules (the "+" keeps the test modules dir separate from the package's). This resolves the tension between the two related records.
Evidence: session 2026-10-29; pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27, learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28.
