id: learning_t585_capture_open_delay_every_open_not_latency_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792829666.315141
edges: [{"target_id": "learning_t585_capture_start_pop_settling_delay_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24", "edge_type": "related"}]
cue: You ask why every SM-T585 capture open takes ~0.2-0.3 s, or consider keeping the mic path powered to cut it.
---

Observed: The 200 ms adc_power_delay hits every capture open, not only at boot. It is open/prepare time, not stream latency (samples are clean from sample 0).
Cause: ASoC DAPM powers capture mic bias and ADC down immediately on stream close; pmdown_time applies to playback only. Desktop stacks (PipeWire suspend-on-idle, ~5 s) close idle sources too, so this matches normal behaviour. Keeping the capture path powered permanently would remove the delay at the cost of power; not needed for the MIDI-pad target. Revisit only if a looper with frequent capture opens comes.
Evidence: measured on hardware 2026-10-24 (open overhead ~0.27 s); see learning_t585_capture_start_pop_settling_delay_2026_10_24 and learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24.
