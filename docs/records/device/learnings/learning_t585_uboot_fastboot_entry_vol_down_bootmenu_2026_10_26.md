id: learning_t585_uboot_fastboot_entry_vol_down_bootmenu_2026_10_26
type: learning
area: device
perspective: agent
created: 1792971055.118151
edges: [{"target_id": "domain_t585_uboot_env_bootmenu_timeout_power_off_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26", "edge_type": "related"}]
cue: You need U-Boot fastboot on the SM-T585 (to flash userdata or update U-Boot) and the key combo does the wrong thing.
---

Observed: Enter U-Boot fastboot: reboot, hold Vol-down alone right after the Samsung logo -> bootmenu -> "Enter Fastboot Mode", Power confirms. Vol-down + Home + Power is Samsung Download (Odin) mode, not U-Boot. U-Boot fastboot enumerates as 04e8:6602 "USB download gadget"; partition aliases are lowercase (boot, userdata). U-Boot can also be updated from running pmOS with dd to /dev/mmcblk0p9.
Cause: The bootmenu is U-Boot's own; Samsung's key combos belong to S-Boot.
Evidence: hardware use 2026-10-26; learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25.
