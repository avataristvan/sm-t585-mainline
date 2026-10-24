id: learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792829645.86934
edges: [{"target_id": "learning_t585_capture_start_pop_settling_delay_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_dapm_delay_event_on_one_widget_only_2026_10_24", "edge_type": "supersedes"}, {"target_id": "domain_t585_jack_switch_module_param_2026_10_24", "edge_type": "related"}]
cue: You put a PRE_PMU delay or other per-channel event on only one of two L/R DAPM widgets, or test a mic path only with both channels on.
---

Observed: Putting the PRE_PMU adc_power_delay only on "Stereo1 ADC Volume L" broke the pop fix whenever only the R path is in use. With jack_switch=1 and a headset plugged, only Headset Mic -> BST1 -> RECMIX1R is active, the L widget never powers up, its event never fires, and the pop came back at full size (~30000). It went unnoticed because the test after that change ran with both mics on.
Cause: DAPM only runs the event of a widget that actually powers up. Having the event on both widgets without a guard runs the delay twice (+0.47 s open instead of +0.27 s), because DAPM coalesces the mute bits into one write and one delay is enough.
Fix: event on BOTH L and R widgets; the event skips the sleep if a delay finished less than 50 ms ago (rt5659_priv.adc_depop_done, jiffies). Verified on hardware: headset only, both mics, main only - all clean from sample 0, each with a single delay (~0.27 s open overhead).
Lesson: when optimizing per-channel DAPM events, test each channel's path alone, not just both together.
Evidence: rt5659 adc_power_delay change, measured on hardware 2026-10-24; boot image a0b677a5... had the broken single-widget delay; see learning_t585_capture_start_pop_settling_delay_2026_10_24.
