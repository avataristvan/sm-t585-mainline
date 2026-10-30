id: domain_t585_public_history_left_as_is_no_rewrite_2026_10_30
type: domain
area: goal
perspective: user
created: 1793386847.916897
edges: [{"target_id": "domain_t585_repo_as_portfolio_root_cause_fixes_upstream_order_2026_10_30", "edge_type": "related"}, {"target_id": "domain_private_access_details_not_in_public_records_2026_10_27", "edge_type": "related"}, {"target_id": "pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27", "edge_type": "related"}]
cue: You consider rewriting, squashing or force-pushing the public sm-t585-mainline history, e.g. to remove a private detail.
---

Decision (user, 2026-10-30): The tablet-user mention in the public main-repo history is left as is (option A). No history rewrite, no force push. Option C follows later: remove the dedicated tablet user when bring-up ends (see CLAUDE.local.md).
Why: Checked across all pushed and local commits: the only private detail is the half-sentence "to the tablet as <dedicated user>" in pattern_t585_fast_kernel_iteration_scp_vmlinuz_modules_tar_2026_10_27 (pushed in 3fcc963, also in local commits before 2616ca7, fixed at the tip). No other access details, passwords or keys anywhere; invoice.pdf never entered history. The detail is harmless, and a rewrite would break the commit hashes quoted in records and docs, which hurts a portfolio repo more.
Scope: History of the public main repo (sm-t585-mainline). Does not relax the rule that new records and docs never name the account (domain_private_access_details_not_in_public_records_2026_10_27).
