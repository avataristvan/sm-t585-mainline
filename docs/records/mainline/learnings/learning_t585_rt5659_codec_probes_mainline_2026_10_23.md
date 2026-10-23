id: learning_t585_rt5659_codec_probes_mainline_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792774427.976406
edges: [{"target_id": "learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23", "edge_type": "related"}, {"target_id": "todo_trim_kernel_config_2026_10_23", "edge_type": "related"}, {"target_id": "domain_priority_audio_bt_dsi_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_tmp_is_tmpfs_refetch_modules_2026_10_23", "edge_type": "related"}]
cue: You continue SM-T585 audio bring-up and need to know what already works for the RT5659 codec (chunk 1 done) and how it is wired in the DTS.
---

Observed: The RT5659 codec probes on mainline 7.3 on the SM-T585 (verified on hardware, kernel #4, boot sha1 facfcd32eca2da3a59bb174731ff52402a3b1be9). i2c5 @13880000 enumerates as i2c-2; the codec is at 2-001b, regs 0xfd=0001, 0xfe=10ec (Realtek), 0xff=6311 (DEVICE_ID). DTS: node audio-codec@1b in &i2c5 with pinctrl group codec_gpio (gpd3-2, gpd3-3 as output) in &pinctrl_top; ldo1-en on gpd3-2 and reset on gpd3-3, both ACTIVE_HIGH, driven high. Modules loaded: soundcore, snd, snd-timer, snd-pcm, snd-pcm-dmaengine, snd-soc-core, snd-soc-rl6231, snd-soc-rt5659. CONFIG_SOUND/SND/SND_SOC/SND_SOC_RT5659=m were added to kernel/gtaxllte-stage1.config; with defconfig this pulls in 75 SND modules (trim candidate, see todo_trim_kernel_config_2026_10_23). Chunk 1 of the audio plan is done; next is chunk 2: I2S0 + PL330 + DISPAUD reset/pad release.
Cause: codec power (LDO1 enable) and reset are plain GPIOs on gpd3-2/3 that the DTS now drives; the codec needs no MCLK for probing.
Evidence: hardware test 2026-10-23 (boot sha1 above); record learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23 for the full signal path.
