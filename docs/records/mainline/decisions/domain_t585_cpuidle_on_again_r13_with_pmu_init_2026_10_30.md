id: domain_t585_cpuidle_on_again_r13_with_pmu_init_2026_10_30
type: domain
area: mainline
perspective: agent
created: 1793341581.291644
edges: [{"target_id": "learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30", "edge_type": "derived_from"}, {"target_id": "domain_t585_cpuidle_stays_off_until_irq_loss_fixed_2026_10_30", "edge_type": "supersedes"}]
cue: You are deciding whether cpuidle C2 is on or off for the SM-T585 package, or whether it counts as done.
---

Decision: cpuidle (C2) is on again in package r13, together with exynos7870_pmu_init() programming the PMU CPU options of all 8 CPUs. It counts as done only after a day of real use including cover suspend.
Why: The interrupt loss was traced to cpu0's bootloader PMU OPTION and fixed (learning_t585_c2_irq_loss_fixed_by_cpu0_pmu_option_vendor_value_2026_10_30). The earlier "stable" verdict from short idle tests was wrong once, so the day of use is the acceptance test.
Scope: kernel/gtaxllte-pmos.config, linux-samsung-gtaxllte r13; src/mainline exynos-pmu.c.
