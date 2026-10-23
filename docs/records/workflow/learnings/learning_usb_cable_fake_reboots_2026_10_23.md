id: learning_usb_cable_fake_reboots_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792778220.245048
edges: [{"target_id": "learning_host_ncm_iface_name_changes_2026_10_23", "edge_type": "related"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}]
cue: The tablet seems to reboot or ttyACM re-enumerates randomly during a stage-1 test.
---

Observed: A crumbling USB cable produced fake "reboots" (ttyACM re-enumeration). One PC port also supplied less than the tablet draws.
Cause: Cable and port power, not the kernel.
Evidence: docs/handoff-2026-10-23.md, section "Update 2026-10-23 evening". Rule out cable and port first, before debugging a supposed crash.
