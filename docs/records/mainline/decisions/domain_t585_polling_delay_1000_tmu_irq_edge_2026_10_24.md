id: domain_t585_polling_delay_1000_tmu_irq_edge_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792854972.159213
edges: [{"target_id": "domain_t585_soc_thermal_trips_81_91_115_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_tmu_irq_rise_fall_works_2026_10_24", "edge_type": "related"}]
cue: Considering polling-delay 0 for soc-thermal, or wondering why the TMU IRQ shows Edge in /proc/interrupts.
---

Decision: polling-delay of soc-thermal stays 1000 ms for now (not 0). Revisit later.
Why: the TMU IRQ still shows Edge in /proc/interrupts despite LEVEL_HIGH in the DT, so interrupt-only operation is not trusted yet (behaviour was verified correct, the display cause is not investigated).
Scope: exynos7870.dtsi soc-thermal.
