id: pattern_t585_reload_audio_modules_from_host_2026_10_24
type: pattern
area: mainline
perspective: the-coder
created: 1792828847.480033
edges: [{"target_id": "learning_t585_machine_module_reload_leaves_playback_silent_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_audio_modules_load_at_boot_from_initramfs_2026_10_24", "edge_type": "related"}]
cue: You changed the rt5659 codec or SM-T585 machine module and want to test it without rebooting or reflashing.
---

Rule: Use kernel/out/alsa/reload.sh to reload the codec and machine modules from the host; arguments go to the machine module, e.g. `... | sh -s -- jack_switch=0`.
When: Iterating on module-only audio changes or module parameters.
Why: Saves a reboot per try. See learning_t585_machine_module_reload_leaves_playback_silent_2026_10_23 for a known reload pitfall.
