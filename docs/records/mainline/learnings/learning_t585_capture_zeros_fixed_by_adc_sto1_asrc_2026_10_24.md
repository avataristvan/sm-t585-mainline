id: learning_t585_capture_zeros_fixed_by_adc_sto1_asrc_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792824545.654982
edges: [{"target_id": "learning_t585_main_mic_in3_micbias2_lineage_ref_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_adc_loopback_zeros_dac_mix_mute_nopm_rt5659_2026_10_24", "edge_type": "related"}]
cue: You capture from the RT5659 on the SM-T585 (mic, pcmrec) and get exact zeros although DAPM powers the path.
---

Observed: Codec-side capture zeros on mainline SM-T585 were caused by the ADC STO1 ASRC being off. Lineage has RT5659 ASRC_2 (0x084) = 0x1001 (DA_STO_T=1 AND AD_STO1_T=1; mixer_paths: "AD STO1 Clk Sel = clk_i2s1_track"); mainline set only DA_STO_T. After the fix pcmrec with Lineage main-mic routing returns real ADC data (startup transient, then noise floor +-2 LSB) instead of exact zeros.
Cause: gtaxllte_link_init in src/mainline/sound/soc/samsung/gtaxllte_rt5659.c set only the DA_STO_T field. It now sets both fields (ASRC_2 = 0x1001); rt5659 then powers "ADC STO1 ASRC" itself (ASRC_1 0x083 = 0x0c08 during capture). Verified after a module swap, no flash.
Caveat: the earlier loopback test (Stereo1 ADC1 Source=DAC MIX) with the fix still gave zeros in one run, but that run started capture alongside playback; not re-tested. The mic path is the verified one.
Evidence: hardware test 2026-10-24, kernel #11 + rebuilt snd-soc-gtaxllte-rt5659.ko; Lineage mixer_paths; resolves the data-path part of todo_t585_codec_capture_returns_zeros_2026_10_23.
