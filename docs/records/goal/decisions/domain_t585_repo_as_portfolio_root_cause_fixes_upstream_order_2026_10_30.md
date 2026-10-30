id: domain_t585_repo_as_portfolio_root_cause_fixes_upstream_order_2026_10_30
type: domain
area: goal
perspective: user
created: 1793380707.200238
edges: [{"target_id": "todo_t585_upstream_dwmmc_exynos_extended_tmout_fix_2026_10_30", "edge_type": "related"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}, {"target_id": "domain_public_repo_gitignore_and_privacy_2026_10_24", "edge_type": "related"}, {"target_id": "domain_private_access_details_not_in_public_records_2026_10_27", "edge_type": "related"}]
cue: Prioritising work, writing commits or docs, or deciding on upstreaming or history rewrites in the public sm-t585-mainline repo.
---

Decision (user, 2026-10-30): The public repo (sm-t585-mainline plus the kernel fork) is the user's reference for job applications and going self-employed in embedded Linux. The user is learning through it and wants proper root-cause fixes, not quick fixes. Agreed order: (1) finish display handover H2 and GPU D3; (2) an upstream block: the dw_mmc-exynos extended-TMOUT fix first (submitted by the user), then the PMU CPU options, then the G3D PLL table, plus the Kaustabh DSI report; (3) a README for outsiders; (4) public-history cleanup, squashing before push. The open history-privacy decision (see FOCUS.md) now leans to option B (rewrite history) or C (remove the access setup after bring-up) rather than A (fix commit only).
Why: The repo doubles as a portfolio, so history, docs and fix quality are read by outsiders; quick fixes would undercut that and the learning goal.
Scope: Prioritisation, commit and doc style, upstream submissions and history rewrites in this repo.
