id: pattern_user_runs_audio_test_with_timed_register_write_2026_10_24
type: pattern
area: workflow
perspective: agent
created: 1792820997.655969
edges: [{"target_id": "learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_propose_measurement_when_listening_stops_converging_2026_10_23", "edge_type": "related"}, {"target_id": "learning_claude_bang_prefix_no_sudo_root_commands_2026_10_25", "edge_type": "related"}]
cue: You are about to ask the user to listen to a hardware test after changing one or more register or mixer settings at once.
---

Rule: When the user tests audio, let them run the test commands themselves via "!" with a timed register write (play a tone, write the register at second 3, ask "tone appears at second 3?").
When: Any by-ear test of a single suspected register or mixer change.
Why: The user can attribute the effect to exactly one change; this is how the DAC mux fix was pinned down (learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24). Complements pattern_propose_measurement_when_listening_stops_converging_2026_10_23.
