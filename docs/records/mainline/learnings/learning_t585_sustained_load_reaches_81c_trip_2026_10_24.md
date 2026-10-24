id: learning_t585_sustained_load_reaches_81c_trip_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792854971.951979
edges: [{"target_id": "domain_t585_cooling_maps_both_clusters_2026_10_24", "edge_type": "related"}]
cue: Judging thermal behaviour or throttling of the T585 under sustained full load at 1690 MHz.
---

Observed: On SM-T585 mainline at 1690 MHz on all 8 cores (busy loops) the SoC zone reaches 79 C within ~30-60 s and the 81 C trip after ~90 s. With the cooling maps it then hovers at 79-81 C, alternating 1690/1586 MHz (state 0/1). Idle after load: ~52 C. So the 81 C trip is reached in real use under sustained full load; stage 1 previously ran at 902 MHz and never got near it.
Cause: full-speed 8-core load heats the SoC past the first passive trip; step_wise then toggles between the top two OPPs.
Evidence: kernel #26 on HW, 2026-10-24, load test with the cooling maps active.
