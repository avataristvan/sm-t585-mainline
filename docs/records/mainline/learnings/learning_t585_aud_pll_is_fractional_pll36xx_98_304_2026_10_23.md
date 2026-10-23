id: learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792784296.575612
edges: [{"target_id": "learning_t585_aud_pll_97_5mhz_not_98_304_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_t585_dispaud_reset_pulse_needed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_aud_pll_request_target_plus_100hz_2026_10_23", "edge_type": "related"}]
cue: You are checking SM-T585 audio sample rates, or clk_summary shows a PLL rate that does not match what playback sounds like.
---

Observed: The 7870 DISPAUD AUD_PLL is a fractional PLL1431x (downstream pwrcal: CLK_PLL(14310, AUD_PLL ...)). Registers after boot: CON0 0xa01e0103 (M=30 P=1 S=3), CON1 0x3f55 (K=16213) -> 26 MHz*(30+K/65536)/8 = exactly 98.304 MHz. Mainline clk-exynos7870.c declared it pll_1417x (integer, ignores K) and reported 97.5 MHz. Consequence: sound/soc/samsung/i2s.c computes psr = rclk_srcrate/fs/rfs = 7.93 and truncates to 7, so real playback ran at 98.304/7/256 = 54.9 kHz (16% fast), not the 0.8% error the old learning assumed.
Cause: Wrong PLL type in the mainline clock driver; the integer type ignores the fractional K. Fix (local mainline patch): declare AUD_PLL as pll_36xx (identical field layout: M[24:16], P[13:8], S[2:0], signed K in CON1[15:0], enable 31, lock 29). After the fix clk reports 98304019 Hz, PSR=0x8700 (/8), prescaler 12.288 MHz = 256fs. Lesson: the clock framework rate can lie when the PLL type is wrong; read CON0/CON1 with memtool before trusting clk_summary.
Evidence: hardware check 2026-10-23 (memtool register reads, clk_summary before/after the patch); downstream pwrcal CLK_PLL(14310, AUD_PLL). Replaces learning_t585_aud_pll_97_5mhz_not_98_304_2026_10_23.
