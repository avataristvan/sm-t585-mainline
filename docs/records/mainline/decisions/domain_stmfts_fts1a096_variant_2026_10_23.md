id: domain_stmfts_fts1a096_variant_2026_10_23
type: domain
area: mainline
perspective: user
created: 1792770177.396856
edges: [{"target_id": "learning_stmfts_fts1a096_not_command_compatible_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_t585_touch_works_stmfts_fts1a096_2026_10_23", "edge_type": "related"}, {"target_id": "domain_stmfts_patches_not_upstreamed_2026_10_23", "edge_type": "related"}]
cue: You are deciding how to get the SM-T585 FTS1A096 touchscreen working: patch stmfts, or write a separate driver.
---

Decision: Support the FTS1A096 by adding a chip variant to mainline stmfts (new compatible, e.g. "st,fts1a096", separate power-on path: register reset, ready polling, INT enable), keeping the FTS4 path untouched. Not a separate driver (user-approved 2026-10-23).
Why: Event format and most commands are shared; a variant is upstreamable, a new driver would duplicate code.
Scope: drivers/input/touchscreen/stmfts in src/mainline plus its binding and the board DTS.
