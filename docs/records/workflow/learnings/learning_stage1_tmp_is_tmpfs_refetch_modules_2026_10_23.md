id: learning_stage1_tmp_is_tmpfs_refetch_modules_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792774428.557991
edges: [{"target_id": "pattern_devsh_for_all_device_commands_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_flash_via_ncm_wget_verified_2026_10_23", "edge_type": "related"}]
cue: You rebooted the SM-T585 after a flash and the sound (or other) modules downloaded earlier are gone.
---

Observed: Files downloaded to /tmp on the stage-1 device (for example the sound modules) are lost on every reboot. After each flash + reboot, re-wget them; kernel/out/snd/load.sh loads them in dependency order.
Cause: /tmp in the initramfs is tmpfs, nothing persists across reboot.
Evidence: audio chunk 1 session 2026-10-23; download flow in learning_stage1_flash_via_ncm_wget_verified_2026_10_23.
