id: learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26
type: learning
area: device
perspective: agent
created: 1792973892.53481
edges: [{"target_id": "todo_t585_uboot_hang_after_no_ethernet_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_uboot_fastboot_entry_vol_down_bootmenu_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_uboot_hs400_off_reboot_stability_passed_2026_10_26", "edge_type": "related"}]
cue: U-Boot on the SM-T585 hangs after "No ethernet found.", or fastboot getvar partition-size fails or says unknown partition table type.
---

Observed: U-Boot eMMC reads were flaky. Several boots hung after "No ethernet found."; in fastboot `getvar partition-size:boot` failed ("invalid partition or device"); `getvar partition-size:0:0` returned the full eMMC (0x747c00000) but `0:9` gave "unknown partition table type". TWRP saw the GPT normally (23 partitions, BOOT=mmcblk0p9), so the GPT is intact and U-Boot's reads are bad. After the fix below the first boot came up into pmOS; the multi-reboot stability test is still pending.
Cause: Hypothesis (not verified): exynos_dw_mmc hardcodes host caps DDR52|HS200|HS400 and U-Boot uses generic tuning, while downstream needs board timings for HS400 (samsung,dw-mshc-ddr200-delay-line = <0x75>, ddr200-timing <1 0 4 0>, enhanced strobe).
Evidence: Fix applied: uboot/gtaxllte.config disables CONFIG_MMC_HS400_SUPPORT, HS400_ES and HS200 (DDR52 max). U-Boot bootcmd now echoes "gtaxllte: bootefi bootmgr" / "gtaxllte: bootefi returned" for on-screen diagnosis. U-Boot can be reflashed from TWRP (adb push + dd to mmcblk0p9) when U-Boot's fastboot cannot see partitions. See todo_t585_uboot_hang_after_no_ethernet_2026_10_26.
