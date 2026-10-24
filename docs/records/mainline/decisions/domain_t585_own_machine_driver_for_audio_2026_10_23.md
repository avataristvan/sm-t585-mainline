id: domain_t585_own_machine_driver_for_audio_2026_10_23
type: domain
area: mainline
perspective: agent
created: 1792784543.386419
edges: [{"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "derived_from"}, {"target_id": "domain_t585_default_audio_routing_in_machine_driver_2026_10_24", "edge_type": "related"}]
cue: You are choosing how to bind I2S0, mixer and RT5659 into a sound card on the SM-T585 (simple-card vs own machine driver).
---

Decision: A small own machine driver for gtaxllte (src/mainline/sound/soc/samsung/gtaxllte_rt5659.c) instead of simple-audio-card / audio-graph-card. Status 2026-10-24: the driver exists and works; headphones and speaker play clean on kernel #11.
Why: The codec needs set_pll(PLL1 from MCLK 26 MHz) which simple-card cannot express; the multi-codec link also needs mixer set_bclk_ratio/sysclk calls (see the two derived learnings).
Scope: SM-T585 audio (mainline).
