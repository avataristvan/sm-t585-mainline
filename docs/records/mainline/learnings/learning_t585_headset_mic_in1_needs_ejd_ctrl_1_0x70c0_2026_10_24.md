id: learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792826506.944441
edges: [{"target_id": "learning_t585_main_mic_in3_micbias2_lineage_ref_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_dump_downstream_regmap_when_port_silent_2026_10_23", "edge_type": "confirms"}, {"target_id": "domain_t585_mics_fixed_mono_tracks_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_loose_plug_looks_like_dead_headset_mic_2026_10_24", "edge_type": "related"}]
cue: You get silence from the SM-T585 headset mic (IN1) on mainline although MICBIAS1 and the RECMIX registers match Lineage.
---

Observed: Headset mic on SM-T585 = IN1 (single-ended) + MICBIAS1 (downstream DT earmic_bias = <1>) + RECMIX1 BST1, IN1 Boost 53. With exactly the Lineage codec state for those (0x064 = 0x8840, 0x00c = 0x3500, RECMIX1 0x03c/0x03e = 0x005f) mainline still recorded silence. Works now without jack detect: 12 s pcmrec shows speech RMS 280-550 vs idle ~18, no manual writes (Lineage with the same headset: RMS 600-950 after Android processing).
Cause: RT5659 EJD_CTRL_1 (0x010). Downstream rt5659.c init_list writes EJD_CTRL_1 = 0x70c0 unconditionally (mainline only for JD_HDA_HEADER; reset value 0x3080); without it the combo jack's mic contact is not connected to IN1.
Fix: gtaxllte_rt5659.c link_init does snd_soc_component_write(EJD_CTRL_1, 0x70c0); "Headset Mic" DAPM_MIC + pin switch, disabled by default (no jack detect); defaults RECMIX1L/R BST1 Switch=1, IN1 Boost 53; DT audio-routing "IN1P","Headset Mic", "IN1N","Headset Mic", "Headset Mic","MICBIAS1". Switch scripts kernel/out/alsa/headsetmic.sh / mainmic.sh. Verified with boot image sha1 e16741dda23059fea353cd20478b38a8f086af70.
Found by: diffing a Lineage dump (headset in, recorder running) against a full mainline hardware dump (kernel/out/alsa/hwdump.sh + regs.txt reads all listed registers via i2cx in 1.6 s).
Evidence: device-dump/sm-t585-audio-ref/lineage-cap-headsetmic/ and lineage-headset-idle/; hardware test 2026-10-24.
