id: learning_t585_sm5703_chunk3b_limiter_verified_module_swap_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792859769.592469
edges: [{"target_id": "domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24", "edge_type": "derived_from"}]
cue: You need to know how chunk 3b (charge limiter) was verified on the SM-T585 or how to test a charger module without flashing.
---

Observed: Chunk 3b verified on HW by module swap only (no flash; kernel #28 still on BOOT, sm5703_charger.ko in kernel/out/batt/): end 12 at 13 % SOC -> "charging paused at 13%", status Not charging, MFD STATUS3 0x0a = 00; end 100 -> resumed, STATUS3 03; end 9 with start 10 -> EINVAL. Implemented by a Sonnet the-coder subagent from a tight brief, reviewed and HW-tested by the orchestrator.
Cause: A charger driver built as module can be swapped on the running stage-1 kernel, so no BOOT write is needed; the next flash bakes it in.
Evidence: domain_t585_sm5703_charge_limiter_software_80_75_2026_10_24; kernel/out/batt/sm5703_charger.ko; kernel #28.
