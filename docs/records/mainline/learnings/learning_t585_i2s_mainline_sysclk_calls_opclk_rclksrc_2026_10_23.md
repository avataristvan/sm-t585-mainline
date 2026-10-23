id: learning_t585_i2s_mainline_sysclk_calls_opclk_rclksrc_2026_10_23
type: learning
area: mainline
perspective: the-coder
created: 1792786754.125527
edges: [{"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23", "edge_type": "related"}]
cue: You are writing the SM-T585 machine driver and copying I2S0 snd_soc_dai_set_sysclk calls from the vendor machine driver.
---

Observed: In the mainline machine driver gtaxllte_rt5659.c: (1) snd_soc_dai_set_sysclk(cpu, SAMSUNG_I2S_OPCLK, 0, SAMSUNG_I2S_OPCLK_PCLK), copied from vendor MOD_OPCLK_PCLK, switches I2S0 to the 99.94 MHz APB clock (I2SMOD bits 31:30 = 3; the 3 s file plays in 3007 ms instead of 2958 ms): leave it out. (2) snd_soc_dai_set_sysclk(cpu, SAMSUNG_I2S_RCLKSRC_1) triggers "refcount_t: addition on 0; use-after-free" in clk_hw_create_clk via i2s_set_sysclk re-getting op_clk: leave it out; opclk0 == opclk1 in our DT anyway and the reset default I2SMOD has RCLKSRC=0. (3) CDCLK out (SAMSUNG_I2S_CDCLK, 512, SND_SOC_CLOCK_OUT) works: I2SMOD 0x00000008.
Cause: The vendor i2s.c differs from mainline samsung i2s; vendor sysclk calls are not safe to copy one to one.
Evidence: hardware tests 2026-10-23 (audio chunk 3c); src/downstream-lineage-21/sound/soc/samsung/universal7870-rt5659.c.
