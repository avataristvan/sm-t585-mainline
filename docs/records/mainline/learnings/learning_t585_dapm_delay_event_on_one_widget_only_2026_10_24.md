id: learning_t585_dapm_delay_event_on_one_widget_only_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792828847.276714
superseded_by: learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24
valid_until: 1792829646.298738
edges: [{"target_id": "learning_t585_capture_start_pop_settling_delay_2026_10_24", "edge_type": "derived_from"}]
cue: You add a PRE_PMU/POST_PMU delay event to DAPM widgets that share one register (e.g. rt5659 ADC volume L/R).
---

Observed: With the delay event on both the L and R widgets of the same register, the delay ran twice (capture open +0.47 s versus +0.27 s with it on one).
Cause: DAPM runs all PRE_PMU events of a sequence, then coalesces the mute bits into one register write, so one delay before that write is enough.
Evidence: rt5659 "Stereo1 ADC Volume L/R" adc_power_delay change, measured on hardware 2026-10-24; see learning_t585_capture_start_pop_settling_delay_2026_10_24.
