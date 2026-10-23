id: learning_t585_pmu_clkout_7870_mainline_wiring_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792785320.986076
edges: [{"target_id": "learning_t585_s1402x_mixer_driver_works_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "derived_from"}]
cue: You wire the RT5659 mclk on the SM-T585 or clk_get of the PMU CLKOUT fails because the 7870 PMU has no clkout match.
---

Observed: PMU CLKOUT on 7870 works via mainline drivers/clk/samsung/clk-exynos-clkout.c after adding the match "samsung,exynos7870-pmu" (exynos5 variant, mux mask 0x1f). Board DTS: &pmu_system_controller gets clocks=<&oscclk>, clock-names="clkout31", #clock-cells=<1>, assigned-clock-parents=<&oscclk>; the RT5659 node uses clocks=<&pmu_system_controller 0>, clock-names="mclk". clk_summary then shows clkout 26 MHz under oscclk.
Cause: Implements the MCLK source found in learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23.
Evidence: hardware check, kernel #8, 2026-10-23 (clk_summary; PMU_DEBUG 0x00001f01).
