id: domain_t585_own_machine_driver_for_audio_2026_10_23
type: domain
area: mainline
perspective: agent
created: 1792784543.386419
edges: [{"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "derived_from"}]
cue: You are choosing how to bind I2S0, mixer and RT5659 into a sound card on the SM-T585 (simple-card vs own machine driver).
---

Decision: PROPOSED by the main session, pending user confirmation: build a small own machine driver for gtaxllte instead of simple-audio-card / audio-graph-card.
Why: The codec needs set_pll(PLL1 from MCLK 26 MHz) which simple-card cannot express; the multi-codec link also needs mixer set_bclk_ratio/sysclk calls (see the two derived learnings).
Scope: SM-T585 audio (mainline), chunk 3 onward. Not valid until the user confirms; then drop this note.
