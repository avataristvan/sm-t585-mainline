id: domain_t585_mics_fixed_mono_tracks_2026_10_24
type: domain
area: mainline
perspective: user
created: 1792827873.679131
edges: [{"target_id": "domain_t585_jack_detect_gpio_only_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_main_mic_in3_micbias2_lineage_ref_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_capture_start_pop_settling_delay_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_mic_panning_summing_in_software_2026_10_24", "edge_type": "related"}]
cue: You are routing SM-T585 capture and wonder why left/right are different mics or want summed mics.
---

Decision (user, 2026-10-24): The mics are fixed mono tracks like on a mixing desk: capture left = main mic (BST3 -> RECMIX1L only), right = headset mic (BST1 -> RECMIX1R only), always, independent of jack_switch. Panning/summing is done in software. Replaces the earlier default where both BSTs fed both RECMIX1 L and R (summed). Helper: kernel/out/alsa/bothmics.sh.
Why: both mics should be usable simultaneously and separately; a hardware sum loses that.
Scope: SM-T585 capture, machine driver defaults. Verified on hardware 2026-10-24 (boot sha1 e9cf1f46c1c7f088569699086e3e68ed6311c46f): tapping the headset mic gives R rms 2500-4900, L ~100 (acoustic crosstalk only).
