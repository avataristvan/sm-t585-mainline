id: learning_devsh_first_ttyacm_and_stale_query_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792790266.321831
edges: [{"target_id": "pattern_devsh_for_all_device_commands_2026_10_23", "edge_type": "related"}]
cue: devsh.py cannot open the device after a reboot, or the first devsh command fails with "sh: /: Permission denied".
---

Observed: After a device reboot the host CDC-ACM node may come back as /dev/ttyACM1 while ttyACM0 is still held; kernel/tools/devsh.py now opens the first /dev/ttyACM* (changed 2026-10-23). Also the first devsh command after a reboot sometimes fails with "sh: /: Permission denied".
Cause: the failure comes from a stale terminal query response left in the input; the ttyACM index depends on the host still holding the old node.
Evidence: kernel/tools/devsh.py (change of 2026-10-23); session observation. Workaround: simply re-run the command.
