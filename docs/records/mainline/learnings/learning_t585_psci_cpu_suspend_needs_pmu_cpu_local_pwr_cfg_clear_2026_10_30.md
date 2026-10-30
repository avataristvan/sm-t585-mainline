id: learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793315636.670749
edges: [{"target_id": "learning_t585_cpuidle_psci_all_or_nothing_staged_test_needs_two_cpus_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_s2idle_keeps_monotonic_clock_running_journald_udevd_watchdog_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_c2_saves_only_8ma_idle_baseline_1_7w_screen_off_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "contradicts"}, {"target_id": "learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30", "edge_type": "related"}]
cue: You are enabling cpuidle power-down states (PSCI CPU_SUSPEND) on the SM-T585 and the core never returns or the system hangs.
---

Observed: On the SM-T585 (Exynos7870, Samsung EL3 firmware, PSCI v0.1) plain PSCI CPU_SUSPEND power-down (arm,psci-suspend-param 0x0010000) does not come back. The core enters and never returns: cpuidle usage stays 0 (it counts only after return), the system later hangs (ping alive, ssh dead), and boot hangs early when the state is active on all CPUs.
Cause: The firmware does not touch the PMU on CPU_SUSPEND. With the kernel clearing CPU_LOCAL_PWR_CFG (0xf) in PMU CPUx_CONFIGURATION (0x10480000 + 0x2000 + ((cluster<<2)|core)*0x80) on CPU_PM_ENTER, and setting it again on CPU_PM_EXIT / ENTER_FAILED, C2 works on all 8 CPUs (PMU status shows cores off, stable under load). This matches downstream enter_c2() -> exynos_cpu.power_down() and the mainline gs101 CPU_INFORM hints. For PSCI CPU_OFF (hotplug) the firmware writes the PMU itself (cfg 0xf -> 0, and it powers cluster 1 down via CPUSEQ_OPTION when its last core goes; CPUSEQ_OPTION stays 1 after online).
Evidence: docs/cpuidle-plan-2026-10-29.md (E1/E2/E3 result sections).
