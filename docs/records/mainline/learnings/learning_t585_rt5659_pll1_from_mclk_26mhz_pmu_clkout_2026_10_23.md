id: learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792784543.010108
edges: [{"target_id": "learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_t585_pmu_clkout_7870_mainline_wiring_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_pll1_from_bclk1_silent_mclk_asrc_works_2026_10_23", "edge_type": "related"}]
cue: You are setting the RT5659 sysclk/PLL for 48 kHz on the SM-T585 or wondering where the codec gets its MCLK.
---

Observed: On the SM-T585 the RT5659 PLL1 at 48 kHz is fed from a 26 MHz MCLK, NOT from BCLK1. Downstream universal7870-rt5659.c aif1_hw_params uses RT5659_PLL1_S_MCLK with JOSHUA_MCLK_FREQ=26000000 -> 24.576 MHz; BCLK1 is only used as PLL source at 192 kHz. The MCLK is the PMU CLKOUT (PMU @0x10480000 + 0xA00 PMU_DEBUG: bits 8-12 select = 0x1F, bit 0 = disable; downstream clock "oscclk_aud" id 470 = pxmxdx_oscclk_aud). Mainline drivers/clk/samsung/clk-exynos-clkout.c has exactly this register layout (0xa00, mux shift 8, gate bit 0) but lacks a samsung,exynos7870-pmu match entry.
Cause: Contradicts the statement "PLL1 fed from BCLK1 - no MCLK wire needed" in learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23 and docs/audio-analysis-2026-10-23.md. A machine setup without MCLK would leave the codec without a usable sysclk at 48 kHz. (The old record could not be rewritten: area is unversioned; read it with this correction.)
Evidence: src/downstream-lineage-21/sound/soc/samsung/universal7870-rt5659.c lines 75-125, 160-275; src/downstream-lineage-21/drivers/soc/samsung/pwrcal/S5E7870/S5E7870-vclk.c:64-80.
