id: todo_t585_uboot_hang_after_no_ethernet_2026_10_26
type: todo
area: device
perspective: agent
created: 1792971054.876509
edges: [{"target_id": "learning_t585_twrp_usb_missing_after_uboot_hang_empty_battery_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26", "edge_type": "related"}]
cue: U-Boot on the SM-T585 hangs or shows a black or frozen screen at boot, or you touch the U-Boot eMMC speed settings.
---

TODO: Confirm the U-Boot eMMC fix with a multi-reboot stability test (several cold and warm boots into pmOS without a hang after "No ethernet found."). Then close this todo.
Background: U-Boot hung (2026-10-26) after "No ethernet found." (that line is normal on every boot); hard reset (Power + Vol-down) and the next boot worked. Cause is now explained, as a hypothesis, by learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26: HS400/HS200 in U-Boot's eMMC init; uboot/gtaxllte.config now limits to DDR52 and the first boot after that worked. If it hangs again: photograph the screen before resetting (bootcmd echoes "gtaxllte: bootefi bootmgr" / "gtaxllte: bootefi returned").
