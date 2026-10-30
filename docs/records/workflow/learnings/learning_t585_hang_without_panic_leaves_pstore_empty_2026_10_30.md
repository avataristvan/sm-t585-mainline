id: learning_t585_hang_without_panic_leaves_pstore_empty_2026_10_30
type: learning
area: workflow
perspective: agent
created: 1793315637.38849
edges: [{"target_id": "pattern_t585_crash_iteration_panic5_boot_entry_fb0_blank_pstore_2026_10_28", "edge_type": "related"}, {"target_id": "learning_t585_pstore_needs_printk8_in_init_2026_10_24", "edge_type": "related"}]
cue: The tablet hung hard without a panic and you hope pstore holds the last log after the reset.
---

Observed: A hang without a panic leaves pstore empty on this device, both after a TWRP restore and after a Power+Vol-down reset. Only panics give a trace.
Cause: pstore only records on panic/oops paths; a hard hang never reaches them.
Evidence: cpuidle session 2026-10-30, docs/cpuidle-plan-2026-10-29.md.
