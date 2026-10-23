id: learning_t585_rt5659_pll1_from_bclk1_silent_mclk_asrc_works_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788230.233748
edges: [{"target_id": "learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "confirms"}, {"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "related"}]
cue: You consider feeding the RT5659 PLL1 from BCLK1 on the SM-T585 instead of the 26 MHz MCLK.
---

Observed: PLL1 sourced from BCLK1 (codec_bfs = 64 or 32 at 48 kHz) gave silence on our setup. The codec-side BCLK ratio of the mixer-codec bus is not known. MCLK + DAC ASRC is the working combination, as in the vendor driver.
Cause: Unknown beyond the unknown BCLK ratio between mixer and codec (see learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23).
Evidence: hardware tests 2026-10-23 (kernel #9 and predecessors); confirms learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23.
