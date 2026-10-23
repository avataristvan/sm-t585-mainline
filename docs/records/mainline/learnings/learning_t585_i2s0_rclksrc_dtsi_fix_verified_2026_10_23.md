id: learning_t585_i2s0_rclksrc_dtsi_fix_verified_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792790265.313154
edges: [{"target_id": "learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23", "edge_type": "confirms"}]
cue: You are about to touch the i2s0 clocks in exynos7870.dtsi or wonder whether the RCLKSRC/PCLK roughness fix is permanent and verified.
---

Observed: The permanent fix for the I2S0 RCLKSRC roughness is in the DTS, not at runtime: src/mainline/arch/arm64/boot/dts/exynos/exynos7870.dtsi, i2s0 node: clocks iis=APB_AUD, i2s_opclk0=APB_AUD (hardware PCLK), i2s_opclk1=MI2S_AUD_I2SCODCLKI, plus assigned-clocks=<&i2s0 CLK_I2S_RCLK_SRC> and assigned-clock-parents=<&cmu_dispaud CLK_GOUT_DISPAUD_MI2S_AUD_I2SCODCLKI> (dt-bindings/sound/samsung-i2s.h included). The machine driver (gtaxllte_rt5659.c) does not call RCLKSRC_1; its comment was corrected.
Cause: see learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23 (RCLKSRC=0 selects PCLK in hardware).
Evidence: after a fresh boot with boot image sha1 97f5b3b00c28c26a172605fe40d4cc2e33bfe86d (kernel #9 Image, new DTB): I2SMOD=0x408 from boot, no refcount warning, pcmplay 144000 frames in 3002 ms, pcmrec 96000 in 2006 ms, mixer loopback spectrum clean; the user heard clean sound on headphones twice.
