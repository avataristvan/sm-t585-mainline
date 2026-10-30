id: todo_t585_upstream_dwmmc_exynos_extended_tmout_fix_2026_10_30
type: todo
area: mainline
perspective: agent
created: 1793375793.399486
edges: [{"target_id": "domain_t585_emmc_hs200_exynos7870_drv_data_extended_tmout_2026_10_30", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}, {"target_id": "domain_t585_repo_as_portfolio_root_cause_fixes_upstream_order_2026_10_30", "edge_type": "related"}, {"target_id": "domain_t585_upstream_postponed_reference_first_push_then_readme_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_kernel_assisted_by_trailer_no_ai_signed_off_by_2026_10_30", "edge_type": "related"}]
cue: You prepare an upstreaming batch for the SM-T585 or are next in contact with Kaustabh Chakraborty about Exynos7870 support.
---

TODO: Send the dw_mmc-exynos extended-TMOUT fix upstream to linux-mmc, cc Kaustabh Chakraborty, who maintains 7870 support. It affects every 7870 board that enables HS200 (none does upstream yet).
Status (2026-10-30): patch prepared on branch upstream/dwmmc-tmout in src/mainline, based on mmc/next, NOT sent; submission postponed by the user (see the postponed-upstream decision). Fixes: 7cbe799ac10f; trailer "Assisted-by: LLM", the human adds Signed-off-by; recipients from get_maintainer.pl plus Kaustabh; the DDR52 "[10:8]=1 by luck" explanation is left out (not re-verifiable).
