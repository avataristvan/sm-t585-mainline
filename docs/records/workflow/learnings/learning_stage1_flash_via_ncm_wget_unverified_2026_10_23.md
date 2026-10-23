id: learning_stage1_flash_via_ncm_wget_unverified_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792769586.909066
superseded_by: learning_stage1_flash_via_ncm_wget_verified_2026_10_23
valid_until: 1792770183.757391
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}, {"target_id": "learning_build_artifacts_not_in_tmp_2026_10_23", "edge_type": "related"}]
cue: You iterate kernel builds on the SM-T585 and want to flash a new image without going through TWRP each time.
---

Observed: UNVERIFIED, not yet exercised. While the device runs stage 1 (no adb), a new image can be pulled over the USB NCM link with busybox wget from a host http server, sha1 verified, then dd'd to mmcblk0p9. TWRP + adb sideload is the fallback.
Cause: stage 1 has no adb, but the USB gadget (NCM) works and busybox is in the initramfs.
Evidence: docs/handoff-2026-10-23.md (plan only); learning_mainline_stage1_boot_t585_2026_10_23.
