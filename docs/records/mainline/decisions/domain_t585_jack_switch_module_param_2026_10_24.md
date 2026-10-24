id: domain_t585_jack_switch_module_param_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792827873.463531
edges: [{"target_id": "domain_t585_jack_detect_gpio_only_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_alsa_ucm_profile_for_pipewire_2026_10_24", "edge_type": "related"}]
cue: You want the SM-T585 jack to stop auto-switching outputs/mics, e.g. to use both mics at once.
---

Decision (user, 2026-10-24): Autoswitching on jack events is configurable by module parameter jack_switch (bool, default 1, perm 0444). 0 = the jack only reports (input event + kctl); pins stay manual (defaults: headphone + main mic).
Why: the user wants both mics usable at the same time.
Scope: gtaxllte_rt5659.c. Verified on hardware 2026-10-24 (boot sha1 e9cf1f46c1c7f088569699086e3e68ed6311c46f): jack_switch=1 switches pins on plug/unplug; jack_switch=0 (module reload via rmmod/insmod) only reports, pins stay.
