id: learning_t585_sm5703_charger_teardown_race_fixed_temp_enodata_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792864120.079925
edges: [{"target_id": "learning_t585_sm5703_charger_zones_verified_temp_offset_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_sm5703_charger_review_findings_2026_10_24", "edge_type": "fixes"}]
cue: You touch SM5703 charger teardown, delayed work or TEMP error handling, or test rmmod/insmod under sysfs writes.
---

Observed: Charger review findings fixed in sm5703_charger.c (commit aa17ce4a9 in src/mainline).
- Teardown race: devm_delayed_work_autocancel is replaced by a devm stop action that calls disable_delayed_work_sync(). Disabling the work makes a later mod_delayed_work from sysfs or the poll's own requeue a no-op, so no stopping flag is needed. This is the kernel idiom (ab8500_fg uses the non-delayed form); the reuse review found it. An earlier version used a stopping flag under the lock plus cancel_delayed_work_sync. INIT_DELAYED_WORK moved before the psy register, because a sysfs write right after registration could hit an uninitialized work.
- TEMP returns -ENODATA when the NTC read failed or before the first poll, instead of the stale value or 0.
Cause: a threshold sysfs write between the work autocancel and the psy unregister could requeue the poll on rmmod; a failed NTC read left the last value in TEMP while health said OVERHEAT.
Evidence: verified on hardware, 10x rmmod/insmod while a loop kept writing thresholds, no oops. Findings listed in docs/handoff-2026-10-24.md and todo_t585_sm5703_charger_review_findings_2026_10_24.
