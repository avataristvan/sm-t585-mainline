id: learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788230.045897
edges: [{"target_id": "learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_capture_zeros_fixed_by_adc_sto1_asrc_2026_10_24", "edge_type": "related"}]
cue: You hear clicks or dropouts from the SM-T585 RT5659 although I2S0 and the PLLs look right, or you set up the codec clocks.
---

Observed: Clicks on the headphone output were caused by the RT5659 running from the 26 MHz MCLK via PLL1 (best rl6231 approximation 24.5818 MHz), which is asynchronous to the AUD_PLL-derived I2S clocks. Fix (verified on hardware, 2026-10-23, kernel #9): enable the codec DAC ASRC, i.e. RT5659 ASRC_2 field DA_STO_T = 1, done in the link .init of the machine driver gtaxllte_rt5659. Mainline rt5659 powers the "DAC STO ASRC" widget itself when that field is set (is_using_asrc). Result: 440 Hz tone audible on both sides, correct pitch, no clicks.
Cause: 24.576 MHz is not reachable exactly from 26 MHz with the RT5659 PLL limits, so codec and I2S clocks drift against each other without ASRC. Lineage runs ASRC_2=0x1001, ASRC_3=0x0011, ASRC_1=0x0c00.
Evidence: hardware test kernel #9 (boot sha1 5fdfe691d665f7958716fb7dc26b1296c2695039) with local modules s1402x-mixer and gtaxllte_rt5659; docs/handoff-2026-10-23.md section "Update 2026-10-23 night"; Lineage register dump (see pattern_dump_downstream_regmap_when_port_silent_2026_10_23).
