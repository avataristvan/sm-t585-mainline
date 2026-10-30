id: domain_private_access_details_not_in_public_records_2026_10_27
type: domain
area: workflow
perspective: user
created: 1793046122.982816
edges: [{"target_id": "domain_public_repo_gitignore_and_privacy_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_background_logger_dies_with_ssh_use_systemd_run_2026_10_27", "edge_type": "related"}, {"target_id": "domain_t585_repo_as_portfolio_root_cause_fixes_upstream_order_2026_10_30", "edge_type": "related"}]
cue: About to record device access details (accounts, credentials, sudo setup, keys) in a record of this public repo.
---

Decision: Private access details for the tablet (accounts, sudo setup, credentials) are never written into public records, docs or CLAUDE.md. They live only in the git-ignored CLAUDE.local.md and docs/records/general/user/. Public records say at most "root on the tablet (see CLAUDE.local.md)".
Why: The repo is public (github.com/avataristvan/sm-t585-mainline); a record describing the access setup would publish how the device can be taken over. A record of this kind was removed on 2026-10-27 for that reason.
Scope: All areas and docs of this repo; applies to record candidates, handoffs and commit plans alike.
