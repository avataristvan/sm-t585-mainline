id: domain_t585_cpuidle_c2_accepted_done_after_r13_use_2026_10_30
type: domain
area: mainline
perspective: user
created: 1793344447.592591
edges: [{"target_id": "domain_t585_cpuidle_on_again_r13_with_pmu_init_2026_10_30", "edge_type": "derived_from"}]
cue: You wonder whether SM-T585 cpuidle C2 is still being tested or may stay on in the package.
---

Decision: cpuidle C2 counts as done and stays on (linux-samsung-gtaxllte r13); the cpuidle chapter is closed. If a hang shows up later, it reopens as a new learning.
Why: r13 (main e87f4cb, src/mainline a9cd4fdb6) was installed from the package on 2026-10-30 and verified on HW: psci_idle, C2 on all CPUs from boot, all 8 PMU OPTION registers 0x10010109, clean reboot, WiFi/BT up. The user used the tablet and reported "läuft gerade gut", which was the acceptance test set in domain_t585_cpuidle_on_again_r13_with_pmu_init_2026_10_30.
Scope: kernel/gtaxllte-pmos.config, linux-samsung-gtaxllte r13, src/mainline exynos-pmu.c.
