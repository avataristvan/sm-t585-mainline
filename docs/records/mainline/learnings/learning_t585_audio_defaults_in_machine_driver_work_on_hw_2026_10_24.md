id: learning_t585_audio_defaults_in_machine_driver_work_on_hw_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792823130.856166
edges: [{"target_id": "learning_t585_rt5659_dapm_mixer_default_needs_kctl_put_after_register_2026_10_24", "edge_type": "confirms"}, {"target_id": "domain_t585_default_audio_routing_in_machine_driver_2026_10_24", "edge_type": "confirms"}]
cue: You doubt that SM-T585 headphone/speaker audio works with no tinymix routing, only machine-driver defaults and pin switches.
---

Observed: On kernel #11 (boot sha1 e13008b307fce06ca5a2b405998e10f60e259d86, release 7.3.0-gtaxllte+), with gtaxllte_set_defaults applying the default routing via kctl put after card registration, headphones AND speaker play clean (user-confirmed by listening) with no tinymix routing at all. setup.sh only loads modules; speaker.sh/headphone.sh only toggle the "Speaker Switch"/"Headphone Switch" pin switches. DAPM during playback: Headphone On, Stereo DAC MIXL On (in 1), DAC L1 On, HP Amp On. So headphones also work through the Stereo DAC Mixer, as in Lineage.
Cause: The defaults now reach the DAPM mixer path because they are set after the kcontrols exist (see the confirmed learning).
Evidence: session 2026-10-24, kernel #11 listening test and debugfs dapm; src/mainline/sound/soc/samsung/gtaxllte_rt5659.c. Still open: machine-module reload leaves playback silent; codec-side capture (mics) returns zeros.
