id: learning_stage1_tinymix_needs_subcommand_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792822788.660251
edges: [{"target_id": "learning_stage1_tinymix_needs_musl_loader_2026_10_23", "edge_type": "related"}]
cue: tinymix on the SM-T585 stage-1 device prints usage or does nothing when called with just a control name.
---

Observed: tinymix (this build) needs the subcommand: `tinymix -D 0 contents` lists controls, `tinymix -D 0 set <control> <value>` sets one.
Cause: newer tinymix CLI syntax.
Evidence: session 2026-10-24 on device.
