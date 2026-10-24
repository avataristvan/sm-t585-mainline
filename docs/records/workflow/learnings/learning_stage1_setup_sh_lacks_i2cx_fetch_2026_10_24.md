id: learning_stage1_setup_sh_lacks_i2cx_fetch_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792826507.760943
edges: [{"target_id": "learning_stage1_tmp_is_tmpfs_refetch_modules_2026_10_23", "edge_type": "related"}]
cue: You need i2cx or a large file on the stage-1 device after a reboot and it is missing or the transfer is cut short.
---

Observed: setup.sh does not fetch i2cx; after a reboot /tmp/i2cx is missing (wget it from http://172.16.42.2:8000/i2cx). Large WAVs via nc may need a longer device-side wait (devsh read time >= 5 s for 2.3 MB).
Cause: /tmp is tmpfs on stage 1 and setup.sh only loads modules.
Evidence: session 2026-10-24; see learning_stage1_tmp_is_tmpfs_refetch_modules_2026_10_23.
