id: domain_bringup_interactive_devteam_for_drivers_2026_10_23
type: domain
area: workflow
perspective: user
created: 1792769194.923695
edges: [{"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "domain_delegate_side_todos_to_smaller_models_2026_10_23", "edge_type": "related"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}]
cue: You are about to hand SM-T585 work to the dev-team or a worktree agent and must decide what to delegate.
---

Decision: Device bring-up steps (DTS, boot-image packaging, flash tests) stay interactive in the main session with the user. The dev-team is used for self-contained driver work (candidates: SM5703 charger/fuel gauge, possibly audio).
Why: The bottleneck is hardware-in-the-loop testing, and the project repo is not git (no worktrees).
Scope: galaxy-tab-a-10.
