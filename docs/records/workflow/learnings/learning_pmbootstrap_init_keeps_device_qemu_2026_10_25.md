id: learning_pmbootstrap_init_keeps_device_qemu_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792956373.943895
edges: [{"target_id": "domain_t585_own_pmos_packages_not_pmaports_2026_10_25", "edge_type": "related"}]
cue: You run pmbootstrap init again and the device setting silently goes back to qemu-aarch64.
---

Observed: A second `pmbootstrap init` kept device=qemu-aarch64. `pmbootstrap config device samsung-gtaxllte` sets the device to the SM-T585.
Cause: not checked; init kept the existing qemu value.
Evidence: pmbootstrap session, 2026-10-25.
