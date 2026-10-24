id: pattern_propose_measurement_when_listening_stops_converging_2026_10_23
type: pattern
area: workflow
perspective: agent
created: 1792788231.039968
edges: [{"target_id": "learning_t585_audio_roughness_volume_independent_open_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_dump_downstream_regmap_when_port_silent_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_mixer_loopback_fft_and_wallclock_rate_check_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_speaker_session_repeated_guessing_loop_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_user_runs_audio_test_with_timed_register_write_2026_10_24", "edge_type": "related"}]
cue: Listening or visual hardware tests have stopped converging after several rounds of tweaks.
---

Rule: When by-ear (or by-eye) tests stop converging, stop guessing and propose an objective measurement (e.g. codec internal loopback captured over I2S RX and analysed by FFT on the host), and compare against the running vendor state early.
When: After about two or three rounds without progress. Audio roughness on the SM-T585 (learning_t585_audio_roughness_volume_independent_open_2026_10_23) is the current case; earlier, the user's question "warum uebernehmen wir nicht moeglichst viel aus dem Downstream dann?" after three silent rounds led to the Lineage register dump.
Why: Each listening round is slow and subjective; a measurement or a vendor-state diff narrows the cause. Complements pattern_dump_downstream_regmap_when_port_silent_2026_10_23.
