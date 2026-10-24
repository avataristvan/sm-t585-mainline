id: learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792823583.475551
edges: [{"target_id": "learning_t585_machine_module_reload_leaves_playback_silent_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_t585_localversion_auto_changes_vermagic_2026_10_24", "edge_type": "related"}]
cue: You rmmod/insmod the machine module (card unbind) and playback is silent although debugfs registers look correct.
---

Observed: After rmmod/insmod of the machine module snd-soc-gtaxllte-rt5659 playback was silent. Hardware reads (i2cx) showed routing 0x2a/0x2d, HP mute 0x02, DAC1 vol 0x19 and the PLL/clock regs 0x80-0x84 all at reset defaults, while debugfs regmap/registers (the cache view) showed the correct values; only the DAPM power regs matched. Without sysclk the codec stays silent. Fixed and verified 2026-10-24 on kernel #11: after rmmod/insmod hw == cache and headphone playback is clean (user-confirmed). Only snd-soc-rt5659.ko changed, so no flash was needed (stable vermagic).
Cause: Mainline rt5659_remove() (component remove, runs when the card unbinds) writes RT5659_RESET but does not mark the regcache dirty. After re-probe the cache still holds the old values, so regmap update_bits skips the writes and the hardware stays at reset defaults.
Fix: in src/mainline/sound/soc/codecs/rt5659.c call regcache_mark_dirty() after the reset in rt5659_remove(), and regcache_sync() at the start of rt5659_probe() (no-op unless dirty).
Evidence: hardware test 2026-10-24 on kernel #11; src/mainline/sound/soc/codecs/rt5659.c; i2cx reads vs debugfs; supersedes the open question in learning_t585_machine_module_reload_leaves_playback_silent_2026_10_23.
