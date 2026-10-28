id: pattern_t585_crash_iteration_panic5_boot_entry_fb0_blank_pstore_2026_10_28
type: pattern
area: workflow
perspective: agent
created: 1793226635.411112
edges: [{"target_id": "learning_t585_test_kernel_changes_vmlinux_btf_modules_fail_allow_mismatch_2026_10_28", "edge_type": "related"}, {"target_id": "learning_t585_dsi_reenable_serror_header_fifo_not_waited_fifoctrl_bits_2026_10_28", "edge_type": "related"}, {"target_id": "pattern_debug_crashing_driver_as_module_panic5_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27", "edge_type": "related"}]
cue: You iterate on a kernel change that panics the SM-T585 on a runtime action (blank/unblank) and each crash needs a manual reset.
---

Rule: Put panic=5 on the options line of the pmos.conf boot entry, then trigger the action over ssh (fb0 blank/unblank). A crash auto-reboots after 5 s and pstore keeps the trace, so no user reset is needed.
When: Crash-iteration of display/driver paths on the running pmOS with a test kernel (see the fast-iteration pattern for installing it); restore with /boot/vmlinuz.good. Bound every wait for the reboot and check the real state.
Why: Without panic=5 each crash is a hard hang needing the user's Power+Vol-down reset. Same idea as the module-based variant, for built-in code.
