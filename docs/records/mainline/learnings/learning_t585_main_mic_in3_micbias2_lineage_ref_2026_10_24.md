id: learning_t585_main_mic_in3_micbias2_lineage_ref_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792824545.857695
edges: [{"target_id": "learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_mics_fixed_mono_tracks_2026_10_24", "edge_type": "related"}]
cue: You get only noise floor from the SM-T585 main mic on mainline; the mic bias / IN3 boost path is not powered.
---

Observed: Main mic on SM-T585 = IN3 with MICBIAS2. Lineage capture dump (recorder app running, pcm0c 48 kHz S16 stereo): RECMIX1L/R BST3 Switch=1, Stereo1 ADC Source=ADC1, Stereo1 ADC1 Source=ADC, Stereo1 ADC MIXL/R ADC1 Switch=1, IN3 Boost Volume=53, Main Mic Switch=On; PWR_ANLG_2 0x064 = 0x2410 (BST3 power bit13, MICBIAS2 bit10, BST3_P bit4). Mainline DAPM had MICBIAS1/2/3 off (no route), 0x064 = 0x2010. Writing 0x064 = 0x2410 via i2cx during pcmrec turned the mic on: noise floor RMS 0.7 -> ambient RMS 20-70.
Fix (verified on hardware 2026-10-24): machine driver gtaxllte_rt5659.c got SND_SOC_DAPM_MIC("Main Mic") + pin switch, and the Lineage defaults (RECMIX1L/R BST3 Switch=1, Stereo1 ADC Source=ADC1, Stereo1 ADC1 Source=ADC, Stereo1 ADC MIXL/R ADC1 Switch=1, IN3 Boost Volume=53). DT exynos7870-gtaxllte.dts audio-routing adds "IN3P","Main Mic", "IN3N","Main Mic", "Main Mic","MICBIAS2". With boot image sha1 0744ad02... (kernel #11 Image, new DTB) and no tinymix/i2cx, DAPM powers MICBIAS2 itself (0x064 = 0x2410 as Lineage); an 8 s pcmrec voice test shows a speech envelope (RMS ~12 idle -> 150-450 speaking, peaks ~6900).
Headset mic (IN1) is a separate path: see learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24.
Evidence: device-dump/sm-t585-audio-ref/lineage-cap-mainmic/; hardware tests 2026-10-24.
