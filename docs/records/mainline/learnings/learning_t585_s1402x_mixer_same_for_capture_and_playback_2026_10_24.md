id: learning_t585_s1402x_mixer_same_for_capture_and_playback_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792824546.068786
edges: [{"target_id": "learning_t585_capture_zeros_fixed_by_adc_sto1_asrc_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "related"}]
cue: You wonder whether the s1402x mixer needs extra AP-side settings for capture on the SM-T585.
---

Observed: The s1402x mixer registers are identical under Lineage during capture and during speaker playback. Capture needs no extra mixer/AP-side setting; DOUTMX1=1 is right for both directions.
Cause: n/a (comparison).
Evidence: diff of device-dump/sm-t585-audio-ref/lineage-spk-play-14880000.s1402x.txt vs lineage-cap-mainmic/mixer.txt is empty.
