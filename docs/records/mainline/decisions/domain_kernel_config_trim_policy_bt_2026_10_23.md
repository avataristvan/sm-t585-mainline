id: domain_kernel_config_trim_policy_bt_2026_10_23
type: domain
area: mainline
perspective: user
created: 1792771128.484253
superseded_by: domain_kernel_config_trim_policy_periph_net_2026_10_23
valid_until: 1792771168.852625
edges: [{"target_id": "domain_kernel_config_trim_policy_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_defconfig_modules_pinned_builtin_2026_10_23", "edge_type": "derived_from"}, {"target_id": "domain_stage1_enable_modules_for_stmfts_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}]
cue: You are about to add a kernel config option, or decide whether something should be =y, =m or dropped for the SM-T585 build.
---

Decision: Kernel config trim policy for the SM-T585. Build in (=y) what the device actually needs; drop everything else instead of building it as =m (no bulk module builds; the user's habit from Gentoo). Modules are acceptable only for (a) USB devices (peripherals attached via OTG, e.g. USB MIDI/audio interfaces), (b) audio devices, (c) Bluetooth: as much support as possible (stack, profiles, HID, BLE/MIDI etc.), (d) drivers under active bring-up (cf. domain_stage1_enable_modules_for_stmfts_2026_10_23). Crypto: keep only software algorithm implementations; drop hardware crypto-accelerator drivers of other SoCs.
Why: Lean music device, 2 GB RAM, 32 MiB BOOT partition, faster builds, no dead code. Bluetooth is wanted broadly (controller use, BLE-MIDI), so it is exempt from the drop rule. Amended the same day by the user; supersedes domain_kernel_config_trim_policy_2026_10_23, which lacked the Bluetooth exception.
Scope: kernel/gtaxllte-stage1.config and kernel/gtaxllte-builtin.config.
