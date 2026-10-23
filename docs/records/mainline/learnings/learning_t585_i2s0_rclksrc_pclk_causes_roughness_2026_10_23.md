id: learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792789907.23249
edges: [{"target_id": "learning_t585_audio_roughness_volume_independent_open_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_t585_i2s_mainline_sysclk_calls_opclk_rclksrc_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_is_exynos7_i2s1_three_clocks_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_roughness_not_player_or_dma_period_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_rclksrc_dtsi_fix_verified_2026_10_23", "edge_type": "related"}]
cue: The SM-T585 headphone tone is rough or ring-modulated, or I2S0 LRCLK/sample rate looks slightly off versus the mixer's 48 kHz.
---

Observed: Root cause of the "ring-modulator" roughness: Exynos7870 I2S0 MOD[10] (RCLKSRC) was 0, which in HARDWARE selects PCLK = APB 99.9375 MHz, not the AUD_PLL codec clock. With PSR /4 and rfs 512, LRCLK = 99937500/4/512 = 48798.6 Hz, while the s1402x mixer runs internally at sysclk 24576005/512 = 48000 Hz, so the mixer drops ~800 samples/s on AP->mixer (and repeats them on the return path).
Cause: The DT assumption "both RCLK mux inputs are the codec clock, as downstream" was wrong: the downstream DT lists the same clock twice only for bookkeeping; the driver's i2s_rclk_src mux therefore reported 98.304 MHz while hardware ran 99.94 MHz. Vendor sets RCLKSRC_1 explicitly.
Fix: DTS i2s_opclk0 = APB (PCLK), i2s_opclk1 = I2SCODCLKI, assigned-clock-parents of the i2s rclk_src mux = I2SCODCLKI (avoids the set_sysclk RCLKSRC_1 path that causes a refcount warning). Runtime test: MOD bit10=1 (memtool 0x148a0004 0x408 while streaming) gave clean sound on headphones (user-confirmed), no spur above -90 dB.
Evidence: mixer-internal loopback (DOUTMX1 DOUT_SEL1=0 = DMIX_OUT, captured with pcmrec) showed sidebands at k*784.6 Hz +- 440 Hz and 1-sample phase jumps every ~61 samples; pcmplay 144000 frames in 2953 ms, pcmrec 96000 in 1973 ms; after the fix pcmrec 96000 frames in 2005 ms, max |d2| equal to the source file. The earlier "playback ~16% fast" AUD_PLL learning was a separate issue.
