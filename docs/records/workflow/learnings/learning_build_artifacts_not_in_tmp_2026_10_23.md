id: learning_build_artifacts_not_in_tmp_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792769586.725666
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}]
cue: You are setting up a long kernel build or tool whose output must survive a PC reboot, and are tempted to use /tmp.
---

Observed: Build artifacts must live in the project (kernel/build, kernel/out, kernel/prebuilt), not in the session scratchpad or /tmp.
Cause: /tmp is tmpfs on this host and is wiped on reboot, so a long build there is lost.
Evidence: findmnt /tmp = tmpfs; kernel/build introduced 2026-10-23; learning_mainline_stage1_boot_t585_2026_10_23.
