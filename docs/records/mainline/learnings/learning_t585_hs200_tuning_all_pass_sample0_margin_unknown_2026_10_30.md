id: learning_t585_hs200_tuning_all_pass_sample0_margin_unknown_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793375792.625553
edges: [{"target_id": "domain_t585_emmc_hs200_exynos7870_drv_data_extended_tmout_2026_10_30", "edge_type": "related"}]
cue: eMMC errors (mmc CRC) appear on the SM-T585 at heat or cold in HS200, or someone considers HS400.
---

Observed: HS200 tuning is all-pass (0xff) on this board; mainline then picks sample 0. Sample 0 passed all tests, but the margin under temperature extremes is not characterised.
Cause: Downstream treats all-pass as untuned (drive-strength retries, ignore-phase bit 7) and has an SM-T58x-specific CONFIG_MMC_TUNING_ALL_PASS_QUIRK that selects sample 7. Mainline has no such handling.
Evidence: downstream gtaxl DTS/defconfig; docs/emmc-speed-plan-2026-10-30.md. If mmc CRC errors ever appear in HS200, this is the first suspect.
