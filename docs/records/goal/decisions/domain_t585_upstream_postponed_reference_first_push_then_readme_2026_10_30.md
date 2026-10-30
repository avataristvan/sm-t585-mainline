id: domain_t585_upstream_postponed_reference_first_push_then_readme_2026_10_30
type: domain
area: goal
perspective: user
created: 1793386848.199589
edges: [{"target_id": "domain_t585_repo_as_portfolio_root_cause_fixes_upstream_order_2026_10_30", "edge_type": "supersedes"}, {"target_id": "domain_t585_public_history_left_as_is_no_rewrite_2026_10_30", "edge_type": "related"}, {"target_id": "todo_t585_upstream_dwmmc_exynos_extended_tmout_fix_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_kernel_assisted_by_trailer_no_ai_signed_off_by_2026_10_30", "edge_type": "related"}]
cue: Resuming the upstream block or the portfolio work, or deciding what to do next with the unpushed commits in the fork and the main repo.
---

Decision (user, 2026-10-30): Upstream submission is postponed; the repo as a reference comes first. Revised order: push (src/mainline to the fork, then the main repo), then a README for outsiders. No squashing: the kernel fork commits are already upstream-style per subsystem (28 pushed + 18 local, fast-forward); the main repo history stays a lab notebook (18 pushed + 20 local, fast-forward). The dw_mmc TMOUT patch is prepared on branch upstream/dwmmc-tmout in src/mainline, based on mmc/next, not sent: Fixes: 7cbe799ac10f ("mmc: dw_mmc: add exynos7870 DW MMC support"), "Assisted-by: LLM" trailer, recipients from get_maintainer.pl plus Kaustabh Chakraborty. The DDR52 "[10:8]=1 by luck" explanation was left out of the upstream message because it could not be re-verified.
Why: The repo doubles as a portfolio; a clean, pushed, documented state matters before outside contact. Squashing would destroy the per-subsystem kernel commits and the hashes quoted in records.
Scope: Order of work after display handover H2 and GPU D3; replaces the upstream-first order and the "squash before push" step of the earlier record.
