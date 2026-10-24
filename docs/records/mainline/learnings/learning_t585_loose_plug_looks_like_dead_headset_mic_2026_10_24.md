id: learning_t585_loose_plug_looks_like_dead_headset_mic_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792828500.266844
edges: [{"target_id": "learning_t585_jack_detect_gpa0_5_active_low_verified_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_jack_detect_gpio_only_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24", "edge_type": "related"}]
cue: An SM-T585 headset-mic capture is silent or near zero and you are about to conclude the channel or routing is broken.
---

Observed: A loose 3.5 mm plug during tests looks like a dead headset-mic channel: R rms ~2, below the normal noise floor of ~20-30.
Cause: the plug not seated, so the headset mic is not connected at all; the capture path itself is fine.
Instead: before interpreting a silent headset-mic capture, check the jack line (GPA0 DAT 0x139f0044 bit 5, 0 = plugged) or the hp-det IRQ count.
Evidence: hardware captures 2026-10-24 on boot sha1 e9cf1f46c1c7f088569699086e3e68ed6311c46f; polarity in learning_t585_jack_detect_gpa0_5_active_low_verified_2026_10_24.
