id: learning_t585_capture_not_running_i2s0_rx_needed_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788676.659374
superseded_by: learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23
valid_until: 1792788954.154798
edges: [{"target_id": "learning_t585_audio_roughness_volume_independent_open_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_roughness_not_player_or_dma_period_2026_10_23", "edge_type": "related"}, {"target_id": "learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23", "edge_type": "related"}]
cue: You want to measure SM-T585 audio objectively via RT5659 loopback and capture with tinycap, which returns instantly with zeros.
---

Observed: Capture on the mainline SM-T585 card does not run yet. tinycap -t 5 reports "Captured 241664 frames" after 0.09 s with all-zero data. /proc/asound/card0/pcm0c/sub0/status stays "closed". RT5659 DAPM never powers AIF1 Capture, even with Stereo1 ADC1 Source = DAC MIX and the ADC switches on. The Alpine tinycap build takes -t (not -T) for the duration.
Cause: The I2S0 RX path (adma channel 2, s1402x towards the AP) does not work yet, so the RT5659 internal loopback measurement (DAC MIX -> Stereo1 ADC) cannot be captured. Treat tinycap's "success" as a userland/RX-path artefact, like the tinyplay case. First make I2S0 RX work, then measure.
Evidence: hardware test 2026-10-23; see learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23 for the same kind of fake success.
