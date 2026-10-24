id: domain_t585_mic_panning_summing_in_software_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792829775.129911
edges: [{"target_id": "domain_t585_mics_fixed_mono_tracks_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_alsa_ucm_profile_for_pipewire_2026_10_24", "edge_type": "related"}]
cue: You want to pan or sum the two SM-T585 mics, or are tempted to use RT5659 RECMIX switches or alsamixer for it.
---

Decision (user, 2026-10-24): Mic panning and summing is done in software, not in hardware via the RT5659 RECMIX routing switches. In the app (DAW/looper) capture ch1 = main mic and ch2 = headset mic appear as two mono inputs; in PipeWire the pro-audio profile exposes the channels separately, and a filter/loopback node does the mixing.
Why: mixing-desk model, the hardware delivers fixed separate tracks. The RECMIX switches (alsamixer) only offer on/off per side plus boost gain, no continuous panning.
Scope: future userspace (postmarketOS with PipeWire). Refines domain_t585_mics_fixed_mono_tracks_2026_10_24, which fixes the hardware side.
