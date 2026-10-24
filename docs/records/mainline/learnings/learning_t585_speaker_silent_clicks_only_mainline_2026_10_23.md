id: learning_t585_speaker_silent_clicks_only_mainline_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792791141.298341
superseded_by: learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24
valid_until: 1792821003.803934
edges: [{"target_id": "todo_t585_speaker_lineage_reference_dump_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2cx_rt5659_register_access_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_dump_downstream_regmap_when_port_silent_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_speaker_rt5659_diffs_not_sufficient_alone_2026_10_24", "edge_type": "related"}]
cue: SM-T585 speakers give only clicks and hiss on mainline though DAPM powers the path, and you are about to try more register tweaks.
---

Observed: SM-T585 speakers on mainline: no tone yet, only class-D switch clicks (on/off) and amplifier hiss. Setup (runtime tinymix, as the Lineage path "dev-speaker"): Stereo DAC MIXL DAC L1 Switch=1, Stereo DAC MIXR DAC R1 Switch=1, DAC L2/R2 Source=Stereo DAC Mixer, SPK MIX DAC L2/R2, SPKVOL, SPO MIX SPKVOL, SPO Playback Switch, card pin "Speaker Switch"=1. These runtime settings are not in kernel/out/alsa/setup.sh yet. The downstream machine routes SPK to SPOL/SPOR (no external amp), confirmed. DAPM powers the whole path; registers read via i2cx during playback look plausible (SPO_VOL 0x0001 no mute, PWR_DIG_1 0x61=0x8f81, PWR_MIXER 0x66=0x3000, PWR_VOL 0x67=0xc000, SPK_L/R_MIXER 0x001e, CLASSD_1 0x0803 set by the spk event).
Tried without effect: levels up to Speaker Playback Volume 16 + DAC1 122 (about -54 dB below full scale; kept low because someone was sleeping); forcing DAC Mono L/R filters (PWR_DIG_2 0x62 |= 0x0300); DIG_MISC 0xfa |= 0x8000 (downstream spk PRE_PMU does this, mainline does not); CLASSD_2 0x011c |= 0x0404 (downstream bits; mainline sets M_RI_DIG bit 11 instead).
Cause: unknown. Caveat: -54 dB may simply be too quiet, not fully excluded. Unknown whether the speakers were ever tested under Lineage on this unit (ask the user). Speaker volume control: value v -> reg 39-v, -46.5 dB + 1.5 dB*v (31 = 0 dB as Lineage).
Evidence: session 2026-10-23 late night (runtime tinymix and i2cx reads); see learning_t585_i2cx_rt5659_register_access_2026_10_23, pattern_dump_downstream_regmap_when_port_silent_2026_10_23.
