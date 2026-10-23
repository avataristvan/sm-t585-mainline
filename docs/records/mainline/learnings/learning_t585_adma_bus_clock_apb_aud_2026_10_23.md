id: learning_t585_adma_bus_clock_apb_aud_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792778219.295489
edges: [{"target_id": "learning_t585_dispaud_reset_pulse_needed_2026_10_23", "edge_type": "related"}]
cue: You are adding the Exynos7870 PL330 ADMA node at 14890000 and its clock, or get a Bus error touching it.
---

Observed: The Exynos7870 ADMA (PL330 @14890000) bus clock is APB_AUD, not APB_AUD_AMP as the downstream clock id suggests. Access with the clock gated gives a Bus error.
Cause: The downstream clock naming is misleading; the ADMA sits behind the APB_AUD gate.
Evidence: docs/handoff-2026-10-23.md, section "Update 2026-10-23 evening".
