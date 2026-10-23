id: learning_http_server_poll_before_device_wget_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792773116.873068
edges: [{"target_id": "learning_stage1_flash_via_ncm_wget_verified_2026_10_23", "edge_type": "related"}]
cue: You transfer files to the stage-1 SM-T585 over NCM with a backgrounded python http.server.
---

Observed: A backgrounded `python3 -m http.server` is not ready immediately. Once the device's wget failed after `rmmod` had already run, leaving touch unloaded.
Cause: the device-side script started before the server listened.
Instead: poll the server with curl from the host until it answers, then let the device run wget; run rmmod only after the download succeeded.
Evidence: session 2026-10-23; procedure in learning_stage1_flash_via_ncm_wget_verified_2026_10_23.
