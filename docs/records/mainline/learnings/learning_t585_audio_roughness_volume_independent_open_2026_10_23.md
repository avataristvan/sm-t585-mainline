id: learning_t585_audio_roughness_volume_independent_open_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788230.629101
superseded_by: learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23
valid_until: 1792789908.02721
edges: [{"target_id": "learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_roughness_not_player_or_dma_period_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_capture_not_running_i2s0_rx_needed_2026_10_23", "edge_type": "related"}]
cue: The SM-T585 headphone tone is audible but rough (ring-modulator-like) and you are about to tweak codec registers by ear.
---

Observed: After the click fix the 440 Hz tone is rough ("ring modulator", "Amiga-like", slightly overdriven), the same at DAC -32 dB, so volume-independent and therefore a digital cause (not found yet, open). Not fixed by: HP path via Stereo DAC Mixer (Lineage path: STO_DAC_MIXER 0x2a8a, DAC L1/R1 Source = Stereo DAC Mixer), ASRC_8 = 0x0120 (vendor rt5659 init_list), I2S BLC (16-bit, I2SMOD 0x00000008 verified correct).
Cause: Unknown. Lead: the vendor rt5659.c has an init_list (BIAS_CUR_CTRL_8, CHOP_DAC, PRE_DIV, MONO_GAIN, CLASSD_0, HP_CALIB_CTRL_7, MONO_NG2_CTRL_2, ASRC_8 = 0x0120, JD/IRQ/GPIO regs, STO_NG2_CTRL_2/3) that mainline does not write in full. Remaining Lineage diffs: HP calibration regs 0x1df.., CLK_DET 0x6b, DIG_MISC 0xfa.
Evidence: hardware listening tests 2026-10-23 night; docs/handoff-2026-10-23.md section "Update 2026-10-23 night". Next step: objective measurement (RT5659 internal loopback DAC MIX -> Stereo1 ADC, captured via I2S0 RX with a pcmrec tool, FFT on host).
