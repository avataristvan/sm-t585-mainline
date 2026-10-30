id: learning_t585_hw_test_duration_by_data_volume_not_minutes_2026_10_30
type: learning
area: workflow
perspective: user
created: 1793346588.991052
edges: [{"target_id": "domain_t585_emmc_ddr52_clock_frequency_cap_highspeed_2026_10_30", "edge_type": "related"}]
cue: You choose how long a hardware verification run should be, e.g. a storage or clock-mode change on the SM-T585.
---

Observed: A 10-minute load test was copied from the cpuidle work for the eMMC speed change; the user questioned it.
Cause: For storage timing, data volume and temperature drift matter, not minutes. A multi-GB read-verify plus 2-3 min load is enough for a mode with wide margin; longer runs only for tight modes (HS200).
Evidence: session 2026-10-30, docs/emmc-speed-plan-2026-10-30.md
