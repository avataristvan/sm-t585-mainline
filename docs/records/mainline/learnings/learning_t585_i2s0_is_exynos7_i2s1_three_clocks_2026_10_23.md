id: learning_t585_i2s0_is_exynos7_i2s1_three_clocks_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792778219.113626
edges: [{"target_id": "learning_t585_adma_bus_clock_apb_aud_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_dispaud_reset_pulse_needed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23", "edge_type": "related"}]
cue: You are wiring the SM-T585 I2S0 node in the DTS or the board hard-freezes when the i2s driver probes.
---

Observed: SM-T585 I2S0 matches the mainline `samsung,exynos7-i2s1` register layout (downstream i2s-v5 + "samsung,i2s-str"), not `samsung,exynos7-i2s`. It needs all three clocks: iis=APB_AUD, i2s_opclk0 = i2s_opclk1 = MI2S_AUD_I2SCODCLKI. With only opclk0 the driver registers a mux with a NULL parent, gets an ERR_PTR and dereferences it -> hard freeze.
Cause: sound/soc/samsung/i2s.c builds its opclk mux from both opclk clocks; a missing one leaves a NULL parent that is not checked.
Evidence: docs/handoff-2026-10-23.md, section "Update 2026-10-23 evening" (chunk 2 hardware tests).
