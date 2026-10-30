id: todo_t585_upstream_dwmmc_exynos_extended_tmout_fix_2026_10_30
type: todo
area: mainline
perspective: agent
created: 1793375793.399486
edges: [{"target_id": "domain_t585_emmc_hs200_exynos7870_drv_data_extended_tmout_2026_10_30", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}]
cue: You prepare an upstreaming batch for the SM-T585 or are next in contact with Kaustabh Chakraborty about Exynos7870 support.
---

TODO: Send the dw_mmc-exynos extended-TMOUT fix (src/mainline 9e129452c) upstream to linux-mmc, cc Kaustabh Chakraborty, who maintains 7870 support. It affects every 7870 board that enables HS200 (none does upstream yet).
