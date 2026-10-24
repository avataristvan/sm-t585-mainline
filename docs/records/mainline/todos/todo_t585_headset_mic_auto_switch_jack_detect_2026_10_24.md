id: todo_t585_headset_mic_auto_switch_jack_detect_2026_10_24
type: todo
area: mainline
perspective: agent
created: 1792826507.155631
edges: [{"target_id": "learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24", "edge_type": "derived_from"}]
cue: You want the SM-T585 to switch between main mic and headset mic automatically on mainline.
---

TODO: Automatic switching main mic <-> headset mic needs jack detection, which is missing on mainline. Today "Headset Mic" is disabled by default and switched by kernel/out/alsa/headsetmic.sh / mainmic.sh.
