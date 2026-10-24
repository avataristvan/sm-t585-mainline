id: pattern_dump_downstream_regmap_when_port_silent_2026_10_23
type: pattern
area: workflow
perspective: agent
created: 1792786743.435998
edges: [{"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_pmu_regmap_cat_hangs_device_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_propose_measurement_when_listening_stops_converging_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_speaker_silent_clicks_only_mainline_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_speaker_dump_lineage_reference_and_roundtrip_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_debugfs_regmap_shows_cache_compare_hw_reads_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24", "edge_type": "related"}]
cue: A minimal mainline port of a vendor driver stays silent or dead after a few guesses from the vendor source.
---

Rule: When a minimal port of a vendor driver stays silent, dump the register state of the running downstream system (boot the Lineage boot.img, adb root, play audio, cat /d/regmap/*/registers) and diff it against mainline, instead of iterating guesses from vendor source.
When: After about two failed attempts. The user prompted this after three silent attempts ("warum uebernehmen wir nicht moeglichst viel ..."). Practical notes under Lineage: no /dev/mem; the regmap of 10480000.system-controller (PMU) exists but `cat registers` hangs (too large), avoid it; playback can be started from adb with `am start -a android.intent.action.VIEW -d file:///sdcard/Music/x.wav -t audio/wav`; adb may drop into MTP-only mode after a while (device vanishes) and must be re-enabled on the tablet.
Why: Vendor HAL-set state (mixer_paths) is visible only in the live register dump, not in the kernel source. See learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23 (found this way after three silent attempts).
