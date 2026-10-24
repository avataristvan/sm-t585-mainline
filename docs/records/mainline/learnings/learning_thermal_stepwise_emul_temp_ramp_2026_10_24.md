id: learning_thermal_stepwise_emul_temp_ramp_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792854971.742594
edges: [{"target_id": "domain_t585_cooling_maps_both_clusters_2026_10_24", "edge_type": "derived_from"}]
cue: Testing thermal cooling maps with emul_temp and seeing only one cooling step.
---

Observed: step_wise only raises the cooling state while the temperature trend is rising. A constant emul_temp (echo 85000 > emul_temp) gives just one step (state 1). To test cooling maps, ramp emul_temp in 1 C steps every 0.5 s: 82 C -> state 2, 84 C -> state 4, 91..97 C -> states 5..11, back to 0 when ramping down. echo 0 restores the real sensor.
Cause: step_wise acts on the trend (raising/dropping), not on the absolute overshoot; a constant fake temperature has no rising trend after the first step.
Evidence: kernel #26 on the SM-T585, 2026-10-24; domain_t585_cooling_maps_both_clusters_2026_10_24.
