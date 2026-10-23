id: learning_t585_audio_roughness_not_player_or_dma_period_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788676.456693
edges: [{"target_id": "learning_t585_audio_roughness_volume_independent_open_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23", "edge_type": "related"}]
cue: You hear roughness in SM-T585 playback and suspect the test player, the WAV, or the DMA period size.
---

Observed: The SM-T585 audio roughness ("ring-modulator") is not caused by the player or by DMA period handling. sine48k.wav is clean (FFT shows only 440 Hz, nothing above -90 dB). pcmplay writes all 144000 frames without xrun in about 2.95 s. Period 256x4 and 4096x4 sound equally rough to the user.
Cause: Not found. A period-boundary glitch would change its rate with the period size (188 Hz vs 12 Hz), so that is ruled out. The cause stays downstream of the player and the DMA buffers (I2S, codec or clocking).
Evidence: hardware listening and FFT tests 2026-10-23; kernel/tools/pcmplay/pcmplay.c; narrows learning_t585_audio_roughness_volume_independent_open_2026_10_23.
