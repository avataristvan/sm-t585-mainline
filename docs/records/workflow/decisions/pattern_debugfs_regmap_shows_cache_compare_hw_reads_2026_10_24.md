id: pattern_debugfs_regmap_shows_cache_compare_hw_reads_2026_10_24
type: pattern
area: workflow
perspective: agent
created: 1792823584.074625
edges: [{"target_id": "learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_i2cx_rt5659_register_access_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_dump_downstream_regmap_when_port_silent_2026_10_23", "edge_type": "related"}]
cue: A register dump looks identical to a working one but the device behaves differently (silent, wrong).
---

Rule: debugfs /sys/kernel/debug/regmap/<dev>/registers shows the regcache for non-volatile registers, not the hardware. When a dump "looks identical" but the device behaves differently, compare against real hardware reads (i2cx for the RT5659; kernel/out/alsa/hwcmp.sh does this for the key regs during playback).
When: Debugging silence or wrong behaviour after module reload, reset, or any path that may desync cache and hardware.
Why: After rt5659_remove() reset the codec without marking the cache dirty, debugfs showed correct values while the hardware sat at reset defaults (see learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24).
Helper: kernel/out/alsa/snap.sh <tag> snapshots codec+mixer regmap, all DAPM widget states and I2S0 regs (read-only memtool) during playback.
