id: learning_t585_machine_module_reload_leaves_playback_silent_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792788230.437933
superseded_by: learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24
valid_until: 1792823583.680222
edges: [{"target_id": "learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_t585_reload_audio_modules_from_host_2026_10_24", "edge_type": "related"}]
cue: You rmmod/insmod snd-soc-gtaxllte-rt5659 to test a change and playback goes silent.
---

Observed: After rmmod/insmod of the machine module (snd-soc-gtaxllte-rt5659) playback stays silent although DAPM state and registers look identical; a fresh boot plus kernel/out/alsa/setup.sh plays fine. Rule of thumb: reboot instead of reloading the machine module when listening tests matter.
Cause: Unknown (open; fixing it is on the NEXT list in FOCUS).
Evidence: hardware tests 2026-10-23 night, docs/handoff-2026-10-23.md section "Update 2026-10-23 night".
