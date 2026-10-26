id: learning_t585_twrp_usb_missing_after_uboot_hang_empty_battery_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792963731.556317
edges: [{"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}, {"target_id": "pattern_t585_recover_boot_via_twrp_stage1_image_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_uboot_env_bootmenu_timeout_power_off_2026_10_26", "edge_type": "related"}, {"target_id": "todo_t585_uboot_hang_after_no_ethernet_2026_10_26", "edge_type": "related"}]
cue: The host does not see the SM-T585 in TWRP at all (no USB enumeration), or TWRP says it cannot mount system.
---

Observed: In TWRP the host sometimes did not see the device at all for a long while (no USB enumeration in the host kernel log), with an empty battery after U-Boot had hung black for about 1 h. After charging and replugging, adb came back. TWRP's "cannot mount system" is expected with pmOS's disk image in SYSTEM and does not affect adb.
Cause: Probably the empty battery (not confirmed; charging plus replug fixed it).
Evidence: session 2026-10-25 U-Boot bring-up; see pattern_t585_recover_boot_via_twrp_stage1_image_2026_10_25.
