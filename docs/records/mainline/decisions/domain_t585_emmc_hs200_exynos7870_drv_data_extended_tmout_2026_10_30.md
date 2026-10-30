id: domain_t585_emmc_hs200_exynos7870_drv_data_extended_tmout_2026_10_30
type: domain
area: mainline
perspective: agent
created: 1793375792.377113
edges: [{"target_id": "learning_t585_hs200_drto_samsung_extended_tmout_format_cause_2026_10_30", "edge_type": "derived_from"}, {"target_id": "domain_t585_emmc_ddr52_clock_frequency_cap_highspeed_2026_10_30", "edge_type": "supersedes"}]
cue: You tune eMMC speed on the SM-T585 or any Exynos7870 board, or wonder why the eMMC runs HS200 and not DDR52.
---

Decision: The eMMC of the SM-T585 runs HS200 (mmc-hs200-1_8v in the board DTS, src/mainline ce946f764). dw_mmc-exynos.c gets its own exynos7870_drv_data (src/mainline 9e129452c) that reuses dw_mci_exynos_set_data_timeout/get_drto_clks, as ARTPEC-8 does, but without the ARTPEC IRQ quirk, because the 7870 reports DTO together with errors. Shipped in package linux-samsung-gtaxllte r15 (pkgrel 15, config unchanged). Read speed: HS200 129.5 MB/s, DDR52 72.7, legacy 20.8.
Why: The extended-TMOUT format fix removes the DRTO failures (see learning_t585_hs200_drto_samsung_extended_tmout_format_cause_2026_10_30). Verified: p19 sha256 equal to the 25 MHz baseline, 6 min eMMC+WiFi load at 39 C, RTC s2idle, 3 reboots, no mmc errors. Pinning vmmc (LDO26) to 2.85 V is not needed (eMMC VCC 2.7-3.6 V), so the old todo is closed.
Scope: SM-T585 mmc0 in mainline, and any 7870 board that enables HS200 (none does upstream yet). HS400 is not covered.
Evidence: docs/emmc-speed-plan-2026-10-30.md, pmos/linux-samsung-gtaxllte/APKBUILD
