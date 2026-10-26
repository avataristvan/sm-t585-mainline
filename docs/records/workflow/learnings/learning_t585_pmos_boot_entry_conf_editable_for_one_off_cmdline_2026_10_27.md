id: learning_t585_pmos_boot_entry_conf_editable_for_one_off_cmdline_2026_10_27
type: learning
area: workflow
perspective: agent
created: 1793044909.295426
edges: [{"target_id": "pattern_t585_panel_power_test_variant_dtb_plus_second_boot_entry_2026_10_27", "edge_type": "related"}]
cue: You want a one-off kernel cmdline on the SM-T585 pmOS (e.g. ignore_loglevel for a hang) without rebuilding any package.
---

Observed: /boot/loader/entries/pmos.conf can be edited directly for one-off cmdline tests (e.g. adding ignore_loglevel).
Cause: systemd-boot reads the entry file as is. boot-deploy rewrites it on the next kernel or device package install, so the edit is temporary; the permanent cmdline lives in kernel-cmdline.conf of device-samsung-gtaxllte.
Evidence: HW session 2026-10-27; pattern_t585_panel_power_test_variant_dtb_plus_second_boot_entry_2026_10_27 (second entry as the safer alternative).
