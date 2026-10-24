id: learning_t585_memtool_bus_error_on_mixer_use_regmap_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792785320.796078
edges: [{"target_id": "learning_t585_s1402x_mixer_driver_works_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_debug_stage1_hangs_memtool_udplog_2026_10_23", "edge_type": "related"}, {"target_id": "learning_memtool_syntax_no_subcommands_hang_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_memtool_works_on_mixer_and_i2s0_during_audio_2026_10_23", "edge_type": "contradicts"}]
cue: You try to read the SM-T585 audio mixer registers at 0x14880000 with memtool and get Bus error.
---

Observed: kernel/tools/memtool (/dev/mem) gave "Bus error" on the mixer registers @0x14880000 even while the mixer was clocked, out of reset and bound (regmap reads work). CONFIG_IO_STRICT_DEVMEM is NOT set, so that is not the cause. A later record reports memtool working on the mixer during audio with the correct syntax and suspects misparsed arguments here (probable, not proven); this record stays as the unreproduced observation. Regmap debugfs is the safe route for the mixer. PMU_DEBUG @0x10480A00 does read fine via memtool: 0x00000000 at boot (CLKOUT enabled, source 0); after our DTS 0x00001f01 (source 31 selected, gated until the codec enables mclk).
Cause: unknown (see learning_t585_memtool_works_on_mixer_and_i2s0_during_audio_2026_10_23 for the likely one).
Evidence: hardware check, kernel #8, 2026-10-23.
