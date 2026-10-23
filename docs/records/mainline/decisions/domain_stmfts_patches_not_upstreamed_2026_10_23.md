id: domain_stmfts_patches_not_upstreamed_2026_10_23
type: domain
area: mainline
perspective: user
created: 1792773115.764323
edges: [{"target_id": "todo_stmfts_pm_runtime_before_register_2026_10_23", "edge_type": "related"}, {"target_id": "domain_stmfts_fts1a096_variant_2026_10_23", "edge_type": "related"}]
cue: You consider sending the stmfts, board DTS or binding patches upstream, or polishing them for upstream submission.
---

Decision: The stmfts (FTS1A096 variant), board DTS and binding patches are not submitted upstream for now.
Why: The user rejected the upstream todo in /reflect on 2026-10-23; the goal is the working music device, not upstream work.
Scope: galaxy-tab-a-2016, mainline patches (stmfts, exynos7870-gtaxllte.dts, samsung-boards.yaml). Revisit only if the user asks.
