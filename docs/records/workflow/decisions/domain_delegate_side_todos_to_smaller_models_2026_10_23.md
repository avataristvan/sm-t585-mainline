id: domain_delegate_side_todos_to_smaller_models_2026_10_23
type: domain
area: workflow
perspective: user
created: 1792773115.942563
edges: [{"target_id": "domain_bringup_interactive_devteam_for_drivers_2026_10_23", "edge_type": "related"}]
cue: You start a todo and decide whether to spawn a cheaper subagent or do it in the main session.
---

Decision: Suitable side todos may be delegated to smaller (cheaper) models. Device bring-up steps stay interactive with the user.
Why: Self-contained side work does not need the main session; hardware-in-the-loop steps do.
Scope: galaxy-tab-a-2016. Complements domain_bringup_interactive_devteam_for_drivers_2026_10_23.
