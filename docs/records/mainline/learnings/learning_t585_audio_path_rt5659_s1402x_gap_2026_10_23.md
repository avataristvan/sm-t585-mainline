id: learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792773934.453692
edges: [{"target_id": "learning_t585_lpass_is_not_exynos5433_lpass_2026_10_23", "edge_type": "related"}, {"target_id": "todo_audio_analysis_lpass_i2s_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_codec_probes_mainline_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_is_exynos7_i2s1_three_clocks_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "related"}]
cue: You are wiring SM-T585 audio (I2S, codec, speakers) and need the signal path and which piece has no mainline driver.
---

Observed: SM-T585 audio path: PL330 adma@14890000 -> I2S0@148A0000 -> s1402x internal audio mixer@14880000 -> pins gpz1-0..3 -> RT5659 codec on i2c5 (0x1b). Speakers are driven by the RT5659 class-D outputs (SPOL/SPOR), no external amp. Codec PLL1 is sourced from BCLK1 (no MCLK). The s1402x mixer has no mainline driver (downstream: exynos-audmixer-v2.c); this is the real gap. Mainline already has the cmu_dispaud audio clocks, pl330, the samsung i2s driver (exynos7-i2s compatibility with downstream i2s-v5 is unverified) and the rt5659 codec.
Cause: The 7870 routes I2S through an on-SoC mixer block that mainline never needed for other Exynos SoCs.
Evidence: docs/audio-analysis-2026-10-23.md.
