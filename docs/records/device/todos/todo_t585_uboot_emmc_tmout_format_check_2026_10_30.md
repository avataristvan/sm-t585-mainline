id: todo_t585_uboot_emmc_tmout_format_check_2026_10_30
type: todo
area: device
perspective: agent
created: 1793375793.13981
edges: [{"target_id": "learning_t585_hs200_drto_samsung_extended_tmout_format_cause_2026_10_30", "edge_type": "derived_from"}, {"target_id": "learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26", "edge_type": "related"}]
cue: You work on U-Boot eMMC speed on the SM-T585 or wonder if the HS200/HS400 flaky reads in U-Boot can be fixed.
---

TODO: Check whether the U-Boot HS200/HS400 flaky reads have the same cause as the kernel's (U-Boot's exynos dw_mmc writes the plain TMOUT format, not the Samsung extended one). If so, a U-Boot fix could enable fast eMMC in the bootloader too. Unverified.
