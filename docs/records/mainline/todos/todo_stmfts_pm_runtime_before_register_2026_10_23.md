id: todo_stmfts_pm_runtime_before_register_2026_10_23
type: todo
area: mainline
perspective: agent
created: 1792772533.008161
edges: [{"target_id": "learning_t585_touch_works_stmfts_fts1a096_2026_10_23", "edge_type": "related"}, {"target_id": "domain_stmfts_patches_not_upstreamed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stmfts_kbd_attach_error_only_on_runtime_insmod_2026_10_23", "edge_type": "related"}]
cue: You are polishing or upstreaming the stmfts patch, or see "failed to attach handler kbd to device" in the SM-T585 boot log.
---

TODO: Fix an upstream-style bug in mainline stmfts: input_register_device() runs before pm_runtime_enable(), so the VT kbd handler's immediate open fails ("input: failed to attach handler kbd to device inputN, error: -13"; pm_runtime_resume_and_get returns -EACCES). Enable runtime PM before registering the input device. Separate small fix, independent of the FTS1A096 variant.
