id: todo_t585_codec_capture_returns_zeros_2026_10_23
type: todo
area: mainline
perspective: agent
created: 1792790265.713487
edges: [{"target_id": "learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_i2s0_rclksrc_dtsi_fix_verified_2026_10_23", "edge_type": "related"}]
cue: You need microphone or codec-side capture on the SM-T585 and pcmrec returns zeros although DAPM powers the capture path.
---

TODO: Codec-side capture still returns all zeros. With RT5659 loopback routing (Stereo1 ADC1 Source=DAC MIX etc.), DAPM powers the codec capture path and s1402x DOUT_SEL1=1 (ADC_DATA), yet pcmrec gets zeros, while the mixer-internal loopback (DOUT_SEL1=0) works. So data codec->mixer is broken: suspects are AIF4IN / codec ADCDAT, the codec I2S1 TX setup, or ADC STO1 ASRC being off. Not needed for playback; needed for microphones later.
