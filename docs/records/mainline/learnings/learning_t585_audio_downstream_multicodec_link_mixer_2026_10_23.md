id: learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792784543.193448
edges: [{"target_id": "learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s_mainline_sysclk_calls_opclk_rclksrc_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_pll1_from_bclk1_silent_mclk_asrc_works_2026_10_23", "edge_type": "related"}]
cue: You are modelling the SM-T585 I2S0 / audio mixer / RT5659 topology in a mainline machine driver or DT graph.
---

Observed: Downstream topology is NOT I2S0 -> mixer -> codec as a codec2codec chain. It is one DAI link with cpu=I2S0 and two codecs {s1402x "AP0", "rt5659-aif1"} (multi-codec), and the mixer is additionally an aux dev. The machine hw_params calls set_bclk_ratio(mixer AP0, 32 at 48k / 64 at 192k), set_fmt I2S CBS_CFS on codec and cpu, I2S CDCLK rfs=512, BFS=32. Mixer sysclk (clock "audmixer_dout" = DOUT_DISPAUD_MIXER) is set to 24.576 MHz (+100) at 48k = AUD_PLL 98.304 / 4. Mixer register map is mmio, reg stride 4 (index*4), 32-bit regmap, clocks audmixer_dout (d1_mixer) + audmixer_aclk.
Cause: The mixer is a bit-clock-ratio/format stage configured by the machine driver alongside the codec, not a separate DAI link.
Evidence: src/downstream-lineage-21/sound/soc/samsung/universal7870-rt5659.c lines 612-660; sound/soc/codecs/exynos-audmixer-v2.c (init_mixer, hw_params), exynos-audmixer-regs.h.
