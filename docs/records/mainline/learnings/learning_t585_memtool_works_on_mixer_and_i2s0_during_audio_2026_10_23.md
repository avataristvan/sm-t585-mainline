id: learning_t585_memtool_works_on_mixer_and_i2s0_during_audio_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792789907.61786
edges: [{"target_id": "learning_t585_memtool_bus_error_on_mixer_use_regmap_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_memtool_syntax_no_subcommands_hang_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23", "edge_type": "related"}]
cue: You want to read or poke SM-T585 mixer (0x14880000) or I2S0 (0x148a0000) registers while audio streams and fear a Bus error.
---

Observed: memtool works on the s1402x mixer (e.g. 0x14880058) and on I2S0 (0x148a0004, e.g. write 0x408) while audio is active, with the correct syntax `memtool <addr> [val]`.
Cause: The earlier Bus error report most likely came from misparsed read/write arguments, not from the hardware (probable, not proven).
Evidence: session 2026-10-23, I2S0 MOD bit10 test (learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23); memtool syntax in learning_memtool_syntax_no_subcommands_hang_2026_10_23.
