id: learning_t585_exynos7870_adc_mainline_support_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792861505.156831
edges: [{"target_id": "domain_t585_sm5703_battery_ntc_exynos_adc_chunk3c_2026_10_24", "edge_type": "related"}]
cue: You need the Exynos7870 ADC (battery NTC, in-bat) in mainline: compatible, register offset, clocks, node, Kconfig symbols.
---

Observed: Exynos7870 ADC works in mainline with a new compatible samsung,exynos7870-adc in drivers/iio/adc/exynos_adc.c (downstream: exynos-adc-v3). Differences: result register at offset 0x08 (data_in_stat flag) instead of 0x0c; init = SOFT_RESET then SOFT_NON_RESET; C_TIME(6); 8 channels; needs both clocks: adc = CLK_GOUT_MIF_WRAP_ADC_IF_PCLK_S0 (critical) and sclk = CLK_GOUT_MIF_WRAP_ADC_IF_OSC_SYS (downstream gate group gate_mif_adcif). Node adc@10550000 in exynos7870.dtsi, GIC_SPI 395 (downstream SPI numbers match mainline). vdd-supply unknown (downstream has none): dummy regulator, dtbs_check warns. Config: IIO re-enabled (was off since the trim) with EXYNOS_ADC=y and GENERIC_ADC_THERMAL=y (the symbol is GENERIC_ADC_THERMAL, not THERMAL_GENERIC_ADC); defconfig's other-board IIO drivers pinned off in gtaxllte-stage1.config.
Readings on stage 1 at room temp (kernel #30): ch1 (battery NTC) 2038-2039 (+-1 noise); ch3 (in-bat) about 2444, which the downstream inbat table maps to 3.80 V while the FG shows 3.64 V under -200 mA (unexplained, not used).
Cause: n/a (new driver support, chunk 3c).
Evidence: kernel #30, BOOT sha1 a011733c640c477dac02d1a6ebdac42f1a9438bd (#29 kept as kernel/out/boot-stage1-k29.img, #28 as boot-stage1-k28.img); downstream data in domain_t585_sm5703_battery_ntc_exynos_adc_chunk3c_2026_10_24.
