id: learning_t585_aud_pll_request_target_plus_100hz_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792785320.416165
edges: [{"target_id": "learning_t585_s1402x_mixer_driver_works_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23", "edge_type": "derived_from"}]
cue: You call clk_set_rate() for an exact audio rate (24.576 MHz) derived from AUD_PLL and the divider lands at /5 instead of /4.
---

Observed: Mainline AUD_PLL (pll_36xx) runs at 98 304 019 Hz, a few Hz above 98.304 MHz. clk_set_rate(24576000) on the mixer sysclk (gout_dispaud_mixer_aud_sysclk -> dout_dispaud_mixer) therefore rounds down to divider /5 = 19.66 MHz. Requesting target+100 Hz (the vendor driver does the same: AUDMIXER_SYS_CLK_FREQ_48KHZ = 24576000U + 100) gives /4 = 24 576 005 Hz. Applies to any exact-rate request derived from AUD_PLL.
Cause: The clk divider rounds down; the PLL is slightly above nominal, so the exact target is unreachable from above.
Evidence: dmesg "s1402x-mixer 14880000.audio-mixer: sysclk 19660804 Hz" before the change, "24576005 Hz" after; clk_summary fout_dispaud_aud_pll 98304019 (hardware, kernel #8, 2026-10-23). Rests on learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23.
