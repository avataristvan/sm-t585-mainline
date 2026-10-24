id: learning_t585_playback_pops_were_test_wav_not_hardware_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792829667.132133
edges: [{"target_id": "learning_t585_speaker_rt5659_diffs_not_sufficient_alone_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23", "edge_type": "related"}]
cue: You hear a pop at the start or end of SM-T585 playback test tones and suspect the codec or DMA.
---

Observed: The playback start/end pops heard on headphones were in the test WAV (unfaded sine), not in the hardware. A sine padded with 300 ms silence and a 50 ms fade is clean on headphones and on the speaker. Playback hardware has no pop issue; the remaining RT5659 register differences versus Lineage are not needed.
Cause: Abrupt signal edges in the test file.
Evidence: listening tests on hardware 2026-10-24; see learning_t585_speaker_rt5659_diffs_not_sufficient_alone_2026_10_24 and learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23.
