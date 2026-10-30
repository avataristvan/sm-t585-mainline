id: todo_emmc_hs200_vmmc_ldo26_2026_10_23
type: todo
area: mainline
perspective: user
created: 1792769587.449693
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_hs200_data_reads_fail_mainline_2026_10_30", "edge_type": "derived_from"}, {"target_id": "domain_t585_emmc_ddr52_clock_frequency_cap_highspeed_2026_10_30", "edge_type": "related"}]
cue: You tune eMMC speed or stability in the SM-T585 board DTS or kernel (DDR52 runs now; HS200 does not).
---

TODO: eMMC HS200 in the driver (low priority, DDR52 already gives 3.5x): desk research first in the downstream dw_mmc-exynos.c HS200 path (see learning_t585_hs200_data_reads_fail_mainline_2026_10_30). Speed step done 2026-10-30 (domain_t585_emmc_ddr52_clock_frequency_cap_highspeed_2026_10_30). Pinning vmmc (LDO26) to 2.85 V like Android is not needed for HS200 (eMMC VCC 2.7-3.6 V).
