# SM-T585 audio: downstream vs mainline 7.3 (analysis, 2026-10-23)

Signal path (downstream `exynos7870-gtaxl_common.dtsi` + `gtaxllte_eur_open_05.dts`):

```
PL330 "adma" @14890000 ─► I2S0 @148A0000 ─► s1402x audio mixer @14880000 ─► pins gpz1-0..3 ─► RT5659 (i2c5 @0x1b)
                                     (DISPAUD sysreg @148F0000: resets, PMU pad retention)          ├─ SPOL/SPOR → speakers (codec class-D, no external amp)
                                                                                                    ├─ HPOL/HPOR → headphones
                                                                                                    └─ IN1 headset mic, IN3 main mic
```

Format: I2S, SoC side master (codec CBS_CFS), RT5659 PLL1 fed from a **26 MHz MCLK** at 48 kHz
(PMU CLKOUT, PMU+0xA00 sel 0x1F; BCLK1 only at 192 kHz) — corrected 2026-10-23, see
learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23.
All on power domain DISPAUD (shared with display; already on via the bootloader).

| Block | Downstream | Mainline 7.3 | Gap |
|---|---|---|---|
| Clocks | `clk-exynos7870.c` (AUD_PLL 98.304 MHz, MI2S, MIXER) | `cmu_dispaud`: FOUT_DISPAUD_AUD_PLL, DOUT_DISPAUD_MI2S/MIXER, GOUT_MI2S_AUD_I2SCODCLKI, GOUT_MIXER_AUD_SYSCLK, APB_AUD | probably complete; AUD_PLL rate table to check |
| "LPASS" @148F0000 | `lpass-exynos7870.c` — really just DISPAUD_CFG @+0x1000 (SW reset bits 0 mixer, 1 MI2S, 2 AMP, 3 ADMA) + PMU pad-retention release (0x3028 / 0x1340) | `exynos-lpass.c` is Exynos5433 (CA5 core, different registers) — **does not fit** | small: reset toggle + pad release; maybe a reset controller / syscon in DTS, or a few lines in the mixer driver |
| DMA | PL330 @14890000, 4 ch, IRQ 73, `apb_pclk` = clock 414 | generic `pl330` | DTS node only; release ADMA reset first |
| I2S0 | `samsung,i2s-v5` (+secondary DAI, rstclr, esa-dma) | `samsung,i2s.c`: `exynos7-i2s` closest (unverified) | DTS node; verify register compatibility |
| Audio mixer s1402x | `exynos-audmixer-v2.c` (2754 lines, mostly ALC/CP/BT controls) | **missing** | new driver; minimal init = ~15 register writes (`audmixer_init_mixer`) + DAI hw_params/bclk ratio |
| RT5659 | vendor driver | `snd-soc-rt5659` with `ldo1-en-gpios` (gpd3-2), `reset-gpios` (gpd3-3) | DTS only; supplies LDO25 1.8 V / LDO32 3.3 V (both always-on) |
| Machine | `universal7870-rt5659.c` | `audio-graph-card` / `simple-audio-card` | DTS + routing; mixer in between needs a DAI-link chain (codec2codec or aux) |
| Jack detect | earjack via ADC ch 2 | no 7870 ADC in mainline | later / skip |

Oddities noted: downstream rt5659 node names `regulator_1v8 = ldo30` (VDD_CAM_CORE 1.2 V) — ignore, LDO25 is the codec 1.8 V.
`lpass_release_pad_reg()` calls `regmap_update_bits(.., 0x10000000, 1)`, which *clears* bit 28.

## Proposed chunks

1. **Probe RT5659 only** (DTS: i2c5 + codec node + gpios, modules `snd-soc-rt5659`). Verify: i2c ID read, driver binds. No sound yet.
2. **I2S0 + PL330 + DISPAUD reset/pad release** (DTS + small sysreg poke). Verify: `aplay` to a dummy-codec card runs without DMA timeout (BCLK visible?).
3. **Minimal s1402x mixer driver** (init sequence + hw_params), then `audio-graph-card` linking I2S0 → mixer → RT5659. Verify: tone on headphones, then speakers.
