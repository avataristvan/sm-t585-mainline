id: learning_t585_capture_start_pop_settling_delay_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792828847.070685
edges: [{"target_id": "domain_t585_mics_fixed_mono_tracks_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_capture_open_delay_every_open_not_latency_2026_10_24", "edge_type": "related"}]
cue: You hear or measure a pop/offset at the start of SM-T585 capture, or touch rt5659 ADC power-up sequencing or adc_power_delay.
---

Observed: The capture-start pop had two parts: (1) 0-10 ms, sample-identical on L and R, decaying from ~+30000 (digital ADC filter settling); (2) 10-150 ms per-channel low-frequency swing (mic bias / boost coupling caps).
Cause: DAPM unmuted the ADC before the analog/digital chain had settled. Fix in mainline sound/soc/codecs/rt5659.c, taken from the vendor driver: "Stereo1 ADC Volume L/R" became SND_SOC_DAPM_PGA_S seq 1 (after mic bias/ADC), and L gets a PRE_PMU msleep(adc_power_delay) before DAPM unmutes the ADC. It runs in stream prepare, so the first captured sample is already settled. Module param adc_power_delay (0644, runtime-writable): the vendor default 100 ms leaves a ~50 ms decaying offset (peak ~1600) on the headset mic; 200 ms is clean from sample 0 on both mics (peak ~60 = noise floor). Default set to 200.
Evidence: verified on hardware with boot sha1 e9cf1f46c1c7f088569699086e3e68ed6311c46f and rebuilt modules (2026-10-24). Resolves todo_t585_capture_start_pop_2026_10_24.
