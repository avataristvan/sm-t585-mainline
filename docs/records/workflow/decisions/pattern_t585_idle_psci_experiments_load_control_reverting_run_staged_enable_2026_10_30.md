id: pattern_t585_idle_psci_experiments_load_control_reverting_run_staged_enable_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793341580.828256
edges: [{"target_id": "learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30", "edge_type": "derived_from"}, {"target_id": "pattern_t585_verify_idle_power_features_with_io_and_reboot_2026_10_30", "edge_type": "related"}]
cue: You plan a hardware power-feature experiment (cpuidle, cluster power-down, suspend) on the SM-T585.
---

Rule: Test idle/PSCI changes with a reproducible load and a control: 10 min random O_DIRECT reads from mmcblk0 plus fsync writes on the tablet, plus bidirectional ssh traffic over WiFi from the host; the same load on the kernel without the feature is the control; a reverting run (one variable back) must reproduce the failure before a fix counts. Enable staged via the default-off CPUIDLE_FLAG_OFF hack, so a hang plus reset boots back without C2 (no TWRP needed). Hosts monitor reachability every 20 s. For experiments without rebuilding, read and write the PMU OPTION at runtime via python mmap of /dev/mem (O_RDWR).
When: Planning further HW power-feature experiments.
Why: Short idle tests gave a wrong "stable" verdict once; this setup separated the causes in five runs plus one reverting run (see learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30).
