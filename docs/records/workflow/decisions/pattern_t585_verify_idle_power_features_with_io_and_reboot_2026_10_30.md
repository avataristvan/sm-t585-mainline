id: pattern_t585_verify_idle_power_features_with_io_and_reboot_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793322710.417536
edges: [{"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "derived_from"}]
cue: You are about to declare a cpuidle or power-management change stable on hardware.
---

Rule: Hardware verification of an idle/power feature must include sustained I/O and a reboot cycle, not only idle sampling.
When: Before declaring a cpuidle or other power-management change stable.
Why: The E3-E6 "stable" verdict came from about 40 min of mostly idle runs and was wrong; E7 (I/O, boot, shutdown) exposed the interrupt loss (learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30).
