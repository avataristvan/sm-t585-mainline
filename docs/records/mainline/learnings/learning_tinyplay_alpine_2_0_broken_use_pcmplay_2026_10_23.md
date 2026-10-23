id: learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792784296.758494
edges: [{"target_id": "todo_tinyplay_returns_instantly_pcm_closed_2026_10_23", "edge_type": "fixes"}, {"target_id": "learning_t585_clk_summary_reboots_2026_10_23", "edge_type": "confirms"}, {"target_id": "learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_tinymix_needs_musl_loader_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_capture_not_running_i2s0_rx_needed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23", "edge_type": "related"}]
cue: tinyplay on the stage-1 SM-T585 prints "playing" and exits in about 10 ms with rc=0 and you suspect the audio driver.
---

Observed: The "tinyplay returns rc=0 instantly" symptom was a userland problem, not the driver. Alpine tinyalsa 2.0 tinyplay prints "playing ..." and exits after ~10 ms without opening the stream (also with -i raw / -p / -n). The raw-ioctl player kernel/tools/pcmplay/pcmplay.c (nolibc, build.sh like i2cx; binary kernel/out/alsa/pcmplay) does HW_PARAMS/PREPARE/WRITEI/DRAIN and plays the 3 s file in 2958 ms on card i2s0-test.
Cause: Alpine tinyalsa 2.0 tinyplay never opens the PCM; the driver chain (I2S0 + PL330 + DISPAUD reset) was fine. Use pcmplay for stage-1 audio tests. Mainline clk_summary read on the stage-1 kernel is safe; the clk_summary-reboots learning is downstream-only (confirmed again).
Evidence: hardware test 2026-10-23, kernel build #7, boot image sha1 3353e4dd964ad54b1122a0298dec53c5c446e8e3; kernel/tools/pcmplay/pcmplay.c.
