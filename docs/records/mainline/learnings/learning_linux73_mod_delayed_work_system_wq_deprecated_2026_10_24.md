id: learning_linux73_mod_delayed_work_system_wq_deprecated_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792859769.829597
edges: [{"target_id": "learning_t585_sm5703_chunk3b_limiter_verified_module_swap_2026_10_24", "edge_type": "related"}]
cue: You queue delayed work in a driver for Linux 7.3 and dmesg says "enqueued on deprecated workqueue".
---

Observed: On Linux 7.3, mod_delayed_work(system_wq, ...) logs "enqueued on deprecated workqueue".
Cause: system_wq is deprecated; schedule_delayed_work uses system_percpu_wq.
Evidence: sm5703_charger.c during chunk 3b (learning_t585_sm5703_chunk3b_limiter_verified_module_swap_2026_10_24). Instead use system_percpu_wq.
