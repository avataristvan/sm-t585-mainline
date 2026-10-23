id: todo_tinyplay_returns_instantly_pcm_closed_2026_10_23
type: todo
area: mainline
perspective: agent
created: 1792778220.437964
edges: [{"target_id": "learning_t585_i2s0_is_exynos7_i2s1_three_clocks_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_adma_bus_clock_apb_aud_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_dispaud_reset_pulse_needed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23", "edge_type": "related"}]
cue: You continue audio chunk 2 on the SM-T585 and tinyplay finishes instantly without sound.
---

TODO: Chunk 2 remaining: tinyplay 2.0 returns rc=0 instantly with the PCM staying closed. Investigate, then verify 3 s of playback without a DMA timeout.
