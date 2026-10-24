id: todo_t585_alsa_ucm_profile_for_pipewire_2026_10_24
type: todo
area: mainline
perspective: the-coder
created: 1792829902.721333
edges: [{"target_id": "domain_t585_mic_panning_summing_in_software_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_jack_switch_module_param_2026_10_24", "edge_type": "related"}]
cue: You bring up postmarketOS/PipeWire on the SM-T585 and see only a generic Pro Audio profile, or kernel and PipeWire both switch the jack.
---

TODO: For the future postmarketOS/PipeWire userspace, write an ALSA UCM profile for card "SM-T585" with devices Speaker, Headphones, Main Mic, Headset Mic and JackControl "Headset Jack", so WirePlumber gets named devices instead of a generic Pro Audio profile.
When UCM/WirePlumber handles jack switching, set the machine driver passive with jack_switch=0 (SND_MACHINE_OPTS in kernel/initramfs/init, or modprobe options in the real rootfs); otherwise kernel and PipeWire switch on top of each other.
No kernel driver change is needed for app/PipeWire mixing.
