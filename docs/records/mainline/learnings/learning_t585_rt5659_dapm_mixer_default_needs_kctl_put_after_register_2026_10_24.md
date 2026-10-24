id: learning_t585_rt5659_dapm_mixer_default_needs_kctl_put_after_register_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792822795.904882
edges: [{"target_id": "learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_audio_defaults_in_machine_driver_work_on_hw_2026_10_24", "edge_type": "related"}]
cue: You set an RT5659 DAPM mixer default in the machine driver and playback stays unpowered although tinymix shows it on.
---

Observed: Setting RT5659 DAPM mixer controls (e.g. "Stereo DAC MIXL DAC L1 Switch", reg 0x2a) by a plain register write in the machine driver's dai_link .init leaves the DAPM path disconnected. Symptom on SM-T585 kernel #10: tinymix shows the switch On, but debugfs dapm shows "Stereo DAC MIXL" with no input; the whole playback path is unpowered (PWR regs 0x61-0x67 = 0); headphones and speaker both silent (user-confirmed). The mux "DAC L1 Source" did pick up the register write.
Cause: DAPM reads a mixer path's connect state only in dapm_connect_mixer, when the codec routes are added at component probe, i.e. before link init and before late_probe. Card late_probe also runs before snd_soc_dapm_new_widgets, so the kcontrols do not exist there yet.
Fix: set DAPM-relevant defaults via snd_soc_card_get_kcontrol() + kctl->put() after devm_snd_soc_register_card() in the machine probe (gtaxllte_set_defaults in src/mainline/sound/soc/samsung/gtaxllte_rt5659.c). Confirmed on hardware with kernel #11 (see learning_t585_audio_defaults_in_machine_driver_work_on_hw_2026_10_24).
Evidence: session 2026-10-24, kernel #10 debugfs dapm and PWR register read-back; src/mainline/sound/soc/samsung/gtaxllte_rt5659.c.
