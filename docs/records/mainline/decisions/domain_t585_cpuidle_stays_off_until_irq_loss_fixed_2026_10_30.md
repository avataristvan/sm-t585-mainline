id: domain_t585_cpuidle_stays_off_until_irq_loss_fixed_2026_10_30
type: domain
area: mainline
perspective: agent
created: 1793322709.938658
edges: [{"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "derived_from"}]
cue: You are deciding whether to re-enable cpuidle on the SM-T585 or revert the C2 commits.
---

Decision: cpuidle stays off (CONFIG_CPU_IDLE off in kernel/gtaxllte-pmos.config, package r12, config identical to r10) until the interrupt loss is fixed. The exynos-pmu 7870 CPU PM notifier and the DT C2 state stay in the tree because they are inert without a cpuidle driver.
Why: C2 loses device IRQs under I/O (learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30). The user delegated the choice before sleeping, so keeping the work in the tree and only switching the driver off was the reversible option.
Scope: kernel/gtaxllte-pmos.config, linux-samsung-gtaxllte r12; main cd889a4; src/mainline 6dbec2e62 and 6edcaed2f (unpushed).
