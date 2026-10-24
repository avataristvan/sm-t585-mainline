id: learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792820997.291824
edges: [{"target_id": "learning_t585_speaker_dump_lineage_reference_and_roundtrip_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_speaker_silent_clicks_only_mainline_2026_10_23", "edge_type": "supersedes"}, {"target_id": "todo_t585_speaker_lineage_reference_dump_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2cx_rt5659_register_access_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_dapm_mixer_default_needs_kctl_put_after_register_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_default_audio_routing_in_machine_driver_2026_10_24", "edge_type": "related"}]
cue: SM-T585 mainline speaker plays only class-D hiss although DAPM powers the path and mixer switches look right.
---

Observed: SM-T585 mainline speakers were silent (class-D hiss only) because RT5659 reg 0x2d A_DAC_MUX bits 3:2 (mainline controls "DAC L1 Source" / "DAC R1 Source") were 0 ("DAC"). Writing 0x2d = 0x000c ("Stereo DAC Mixer" for L1/R1) during speaker playback made the tone appear immediately (user-confirmed, tone exactly at the write). Lineage speaker playback has 0x2d = 0x000c; Lineage headphone playback had 0x000f.
Also needed in the route: "Stereo DAC MIXL DAC L1 Switch"=1 and "Stereo DAC MIXR DAC R1 Switch"=1 (Lineage mixer_paths dev-speaker sets them).
Cause: DAC L1/R1 Source left at "DAC" instead of "Stereo DAC Mixer". A_DAC_MUX alone is sufficient: after a clean reboot + setup.sh, using only tinymix ('Stereo DAC MIXL DAC L1 Switch' 1, 'Stereo DAC MIXR DAC R1 Switch' 1, 'DAC L1 Source' 'Stereo DAC Mixer', 'DAC R1 Source' 'Stereo DAC Mixer', 'Headphone Switch' 0, 'Speaker Switch' 1, 'Speaker Playback Volume' 31 31) the user heard the tone clearly. Read-back during play: 0x2d=000c, 0x11c=0950, 0x6b=0009, 0xfa=0001, i.e. all mainline values except 0x2d.
Evidence: Lineage vs mainline dumps in device-dump/sm-t585-audio-ref/ (see learning_t585_speaker_dump_lineage_reference_and_roundtrip_2026_10_24); timed register write test and clean-reboot tinymix verification, session 2026-10-24; helper script kernel/out/alsa/speaker.sh (run after setup.sh). Replaces learning_t585_speaker_silent_clicks_only_mainline_2026_10_23 (cause unknown there).
