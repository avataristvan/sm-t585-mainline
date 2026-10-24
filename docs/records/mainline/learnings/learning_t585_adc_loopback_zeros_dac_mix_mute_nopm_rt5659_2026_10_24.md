id: learning_t585_adc_loopback_zeros_dac_mix_mute_nopm_rt5659_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792826652.591456
edges: [{"target_id": "learning_t585_capture_zeros_fixed_by_adc_sto1_asrc_2026_10_24", "edge_type": "related"}]
cue: You route RT5659 ADC loopback (Stereo1 ADC1/ADC2 Source = DAC MIX) on the SM-T585 and capture is exact zeros although DAPM is fully on.
---

Observed: RT5659 ADC loopback (Stereo1 ADC1/ADC2 Source = "DAC MIX") returned exact zeros. After the fix, during loopback 0x02c = 0x000f (afterwards 0x00af again), both channels carry the 440 Hz sine, RMS 528, from 0.2 s.
Cause: mainline rt5659.c declares the "DAC MIXL"/"DAC MIXR" muxes with SND_SOC_NOPM, so DAPM never clears the mute bits M_DAC_MIX_L/R in DIG_MIXER 0x02c (bits 7/5, set by default; Lineage idle 0x00af). Downstream rt5659.c has the same mux ("DAC MIXL Mux") on RT5659_DIG_MIXER, RT5659_M_DAC_MIX_L/R_SFT, invert 1. Found by comparing the Stereo1 ADC L1 Mux "DAC MIX" route in both trees; confirmed by clearing the bits via i2cx during loopback.
Fix: src/mainline/sound/soc/codecs/rt5659.c, both widgets now use RT5659_DIG_MIXER / RT5659_M_DAC_MIX_{L,R}_SFT / invert 1 (they feed only the ADC loopback, no playback path). rt5659 is a module loaded from kernel/out/snd, so the fix is active via setup.sh, no flash needed (boot image e16741dd...). Genuine mainline rt5659 bug, upstream-worthy; no upstreaming planned.
Evidence: hardware test 2026-10-24 after swapping snd-soc-rt5659.ko; resolves todo_t585_adc_loopback_returns_zeros_2026_10_24.
