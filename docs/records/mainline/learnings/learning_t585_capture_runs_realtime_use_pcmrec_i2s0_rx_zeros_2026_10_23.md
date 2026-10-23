id: learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788953.94199
edges: [{"target_id": "learning_t585_capture_not_running_i2s0_rx_needed_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "related"}, {"target_id": "todo_t585_codec_capture_returns_zeros_2026_10_23", "edge_type": "related"}]
cue: You want to capture SM-T585 audio via RT5659 loopback and tinycap returns instantly, or I2S0 RX data is all zeros.
---

Observed: Capture DOES run in real time on the mainline SM-T585 card; the instant return of tinycap was an Alpine tinycap artefact. Use kernel/tools/pcmplay/pcmrec.c (raw-ioctl capture, sibling of pcmplay; build: `build.sh <kbuild> <out> pcmrec.c`, binary kernel/out/alsa/pcmrec): it reads 96000 frames in 1973 ms. With RT5659 loopback routed (Stereo1 ADC1 Source=DAC MIX, Stereo1 ADC MIXL/R ADC1 Switch=1, STO1 ADC Capture Switch=1) and playback running concurrently, codec DAPM powers the whole capture path (AIF1 Capture ... DAC MIXL on; only ADC STO1 ASRC off), yet I2S0 RX data is all zeros.
Cause: open. Pinmux gpz1-0..3 func2 matches downstream i2s-pmic-bus-extcodec. s1402x DOUTMX1 DOUT_SEL1=1 means ADC_DATA (codec->AP) per the vendor regs header, so mixer routing looks right. Unknown whether codec ADCDAT reaches the mixer; next test is DOUT_SEL1=0 (DMIX_OUT) to loop back inside the mixer.
Evidence: hardware test 2026-10-23; corrects learning_t585_capture_not_running_i2s0_rx_needed_2026_10_23 (cause "RX path does not run" was wrong); see learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23 for the same userland-tool artefact pattern.
