id: domain_kernel_config_trim_policy_periph_net_2026_10_23
type: domain
area: mainline
perspective: user
created: 1792771168.303846
edges: [{"target_id": "domain_kernel_config_trim_policy_bt_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_defconfig_modules_pinned_builtin_2026_10_23", "edge_type": "derived_from"}, {"target_id": "domain_stage1_enable_modules_for_stmfts_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}]
cue: You are about to add a kernel config option, or decide whether something should be =y, =m or dropped for the SM-T585 build.
---

Decision: Kernel config trim policy for the SM-T585. Build in (=y) what the device actually needs; drop everything else instead of building it as =m (no bulk module builds; the user's habit from Gentoo). Protected/flexible side, where modules are acceptable and nothing may be cut away: (a) USB devices (peripherals attached via OTG, e.g. USB MIDI/audio interfaces), (b) audio devices, (c) Bluetooth: as much support as possible (stack, profiles, HID, BLE/MIDI etc.), (d) peripheral drivers and the networking stack ("peripherietreiber und Netzwerk muss laufen"), (e) drivers under active bring-up (cf. domain_stage1_enable_modules_for_stmfts_2026_10_23). Ballast to drop: drivers for hardware of other SoCs/boards. Crypto: keep only software algorithm implementations; drop hardware crypto-accelerator drivers of other SoCs.
Why: Lean music device, 2 GB RAM, 32 MiB BOOT partition, faster builds, no dead code. Peripherals, networking and Bluetooth are wanted broadly (controller use, BLE-MIDI, USB gadget/NCM debug), so they are exempt from the drop rule. Amended twice by the user on 2026-10-23; supersedes domain_kernel_config_trim_policy_bt_2026_10_23 (no peripheral/network clause).
Scope: kernel/gtaxllte-stage1.config and kernel/gtaxllte-builtin.config.
