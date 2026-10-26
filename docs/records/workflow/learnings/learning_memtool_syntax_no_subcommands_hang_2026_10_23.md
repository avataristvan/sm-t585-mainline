id: learning_memtool_syntax_no_subcommands_hang_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792788953.744183
edges: [{"target_id": "learning_t585_memtool_bus_error_on_mixer_use_regmap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_memtool_works_on_mixer_and_i2s0_during_audio_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_t585_debug_delays_as_runtime_module_params_bisect_2026_10_26", "edge_type": "related"}]
cue: You are about to poke a hardware register on the SM-T585 with memtool and assume r/w subcommands exist.
---

Observed: kernel/tools/memtool syntax is `memtool <hex-addr> [hex-value]` (read, or write-then-read). It has NO r/w subcommands. `memtool w 0x14880058 0` parsed "w" as the address (~phys 0) and wrote 0x14880058 there; the device hung and needed a manual reboot. `memtool r <addr>` silently reads phys ~0, not <addr>.
Cause: argv handling takes the first argument as a hex address, so a letter subcommand becomes an address of 0.
Evidence: hardware incident 2026-10-23; check kernel/tools/memtool/memtool.c argv handling before poking registers with any tool.
