id: domain_t585_lean_linux_music_device_2026_10_23
type: domain
area: goal
perspective: user
created: 1792769193.763086
superseded_by: domain_t585_general_lean_tablet_not_music_only_2026_10_25
valid_until: 1792956389.476641
edges: [{"target_id": "domain_target_device_sm_t585_2026_10_23", "edge_type": "related"}, {"target_id": "decision-p613-android-over-pmos", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_bt_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_userspace_postmarketos_not_lineage_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sdl3_kmsdrm_pad_grid_multitouch_2026_10_25", "edge_type": "related"}]
cue: You wonder whether this project is still on hold, what the device is for, or what to do if Linux bring-up fails.
---

Decision: Revive the SM-T585 as a lean-Linux music device (reopened explicitly by the user on 2026-10-23). Ideas: USB-MIDI pad controller (f_midi gadget), synth/looper, Mixxx, Spotify player. First target: USB-MIDI pad controller (needs only display, touch, USB device mode). Fallback if Linux fails: older LineageOS (19.1/20) with apps like TouchDAW; otherwise the user disposes of the device. This replaces the "on hold" focus of 2026-09-10 and the deprioritization in decision-p613-android-over-pmos for this repo; the P613 decision itself stays valid for the other tablet.
Why: LineageOS 21 is too heavy for 2 GB RAM.
Scope: galaxy-tab-a-2016 (the repo was named galaxy-tab-a-10 before).
