id: pattern_mixer_loopback_fft_and_wallclock_rate_check_2026_10_23
type: pattern
area: mainline
perspective: agent
created: 1792789907.427084
edges: [{"target_id": "learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23", "edge_type": "derived_from"}, {"target_id": "pattern_propose_measurement_when_listening_stops_converging_2026_10_23", "edge_type": "confirms"}]
cue: You need an objective check of the SM-T585 AP-side digital audio path without relying on the codec or on listening.
---

Rule: Measure the AP-side digital path with the s1402x mixer-internal loopback (DOUTMX1 DOUT_SEL1 = DMIX_OUT), capture with pcmrec, then host FFT plus a time-offset fit against an ideal sine. As a cheap sample-rate check, compare wall-clock time of pcmplay/pcmrec for a known frame count (expect frames/48000 s).
When: Audio sounds wrong (roughness, pitch, clicks) and listening rounds stop converging; the codec is to be excluded.
Why: It found the I2S0 RCLKSRC=PCLK rate error (learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23) after listening sessions had not converged; it confirms pattern_propose_measurement_when_listening_stops_converging_2026_10_23.
