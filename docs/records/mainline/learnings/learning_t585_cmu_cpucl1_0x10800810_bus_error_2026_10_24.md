id: learning_t585_cmu_cpucl1_0x10800810_bus_error_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792853978.057593
edges: [{"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_cpu_numbering_cmu_and_cpuloop_tool_2026_10_24", "edge_type": "related"}]
cue: Dumping CMU_CPUCL1 registers with memtool and a read at 0x10800810 raises a bus error.
---

Observed: CMU_CPUCL1 register 0x10800810 (CLK_ENABLE ATCLK in downstream naming) gives a bus error on read; CPUCL0's 0x10900810 reads fine. Do not touch it (also not in register sweeps).
Cause: unknown; not investigated.
Evidence: memtool reads on the SM-T585, 2026-10-24 (kernel #25).
