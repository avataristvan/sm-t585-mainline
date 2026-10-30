id: learning_t585_psci_wakeup_from_c2_works_on_non_boot_cpu_gic_hypothesis_refuted_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793341580.347729
edges: [{"target_id": "learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30", "edge_type": "related"}]
cue: You suspect GIC or firmware wakeup problems with PSCI idle (C2) on the SM-T585.
---

Observed: SPI wakeup from C2 works on a non-boot CPU. With the eMMC and WiFi IRQs moved to cpu5 (smp_affinity) and C2 on cpu1-7, cpu5 handled 2M+140k IRQs with ~270k C2 entries and no loss.
Cause: Hypothesis H6 (GIC/firmware wakeup loss) is refuted; the loss is a cpu0 PMU option problem, not the GIC.
Evidence: docs/cpuidle-plan-2026-10-29.md debug plan 2 F2; learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30.
