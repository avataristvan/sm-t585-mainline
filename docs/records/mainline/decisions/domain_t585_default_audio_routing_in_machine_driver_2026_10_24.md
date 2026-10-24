id: domain_t585_default_audio_routing_in_machine_driver_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792822788.283481
edges: [{"target_id": "learning_t585_rt5659_dapm_mixer_default_needs_kctl_put_after_register_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_own_machine_driver_for_audio_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_defaults_in_machine_driver_work_on_hw_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_jack_detect_gpio_only_2026_10_24", "edge_type": "related"}]
cue: You are about to route SM-T585 audio (headphones or speaker) with tinymix or a setup script instead of relying on machine-driver defaults.
---

Decision: Default audio routing lives in the machine driver: DAC1 -> Stereo DAC Mixer (L1->L, R1->R) -> DAC L1/R1 Source = Stereo DAC Mixer for BOTH headphones and speaker (Lineage does the same: 0x2d=0x000f on HP, 0x000c on SPK, 0x2a=0x2a8a in both), HPO L/R switches on, DAC1 at 122 (-20 dB), ASRC on, Speaker pin disabled by default. Output selection via the card pin switches "Headphone Switch"/"Speaker Switch" (kernel/out/alsa/speaker.sh, headphone.sh); setup.sh no longer does routing.
Why: stage-1/lean Linux has no UCM and the board routing is fixed, so the defaults belong in the driver, not in scripts.
Scope: SM-T585 audio.
