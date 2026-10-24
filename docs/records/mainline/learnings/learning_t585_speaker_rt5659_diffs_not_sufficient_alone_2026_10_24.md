id: learning_t585_speaker_rt5659_diffs_not_sufficient_alone_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792820997.472733
edges: [{"target_id": "learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_speaker_silent_clicks_only_mainline_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_playback_pops_were_test_wav_not_hardware_2026_10_24", "edge_type": "related"}]
cue: You are tempted to copy another Lineage-vs-mainline RT5659 register difference to fix silent speakers on the SM-T585.
---

Observed: Other RT5659 differences Lineage vs mainline during speaker play were tested and are NOT sufficient alone: DIG_MISC 0xfa bit15 (downstream spk_event sets it); CLASSD_2 0x11c 0x0404 bits (downstream) vs M_RI_DIG 0x0800 (mainline); CLK_DET 0x6b (mainline routes "SYS CLK DET" to SPK Amp, downstream does not); SILENCE_CTRL 0x15; ASRC_3 0x85; ASRC_8 0x8a; DAC1 volume 0x19.
Cause: the decisive difference was A_DAC_MUX 0x2d, see learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24. Confirmed: with 0x2d fixed and all of the above at mainline values, the speaker plays.
Evidence: device-dump/sm-t585-audio-ref/lineage-spk-play-5-001b.txt vs mainline-spk-play-2-001b.txt; session 2026-10-24.
