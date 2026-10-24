id: domain_t585_jack_detect_gpio_only_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792827873.256603
edges: [{"target_id": "learning_t585_jack_detect_gpa0_5_active_low_verified_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_default_audio_routing_in_machine_driver_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_loose_plug_looks_like_dead_headset_mic_2026_10_24", "edge_type": "related"}]
cue: You are adding headset jack detection or 3/4-pole/button detection for the SM-T585 audio card.
---

Decision (user, 2026-10-24): Jack detection option (a), GPIO-only. Machine driver gtaxllte_rt5659.c creates snd_soc_jack "Headset Jack" with snd_soc_jack_add_gpios; DT hp-det-gpios = <&gpa0 5 GPIO_ACTIVE_LOW>, pinctrl jack_det = EINT with pull none, debounce 200 ms. A plug is assumed to be a headset (no ADC, so no 3/4-pole distinction). Jack pins: Headphone + Headset Mic on insert; Speaker + Main Mic inverted.
Why: ADC v3 detection of 3/4-pole and buttons is a separate driver project, not worth it for a MIDI pad device; it can be added later (option b).
Scope: SM-T585 audio machine driver. Verified on hardware 2026-10-24 (boot image sha1 e9cf1f46c1c7f088569699086e3e68ed6311c46f): unplugged -> Speaker + Main Mic on, plugged -> Headphone + Headset Mic on, hp-det IRQ fires. Resolved the former todo for automatic main/headset mic switching (closed).
