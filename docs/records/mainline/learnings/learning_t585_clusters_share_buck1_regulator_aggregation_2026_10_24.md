id: learning_t585_clusters_share_buck1_regulator_aggregation_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792850174.184426
edges: [{"target_id": "learning_t585_opp_microvolt_triplet_shared_buck1_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_gpu_supply_is_buck2_shared_mif_int_disp_cam_not_buck3_2026_10_30", "edge_type": "related"}]
cue: Wiring cpu-supply for two cpufreq-dt policies (cl0/cl1) on the T585 and wondering about the shared regulator.
---

Observed: Both clusters share BUCK1 (S2MPU05). With cl0 at 1248 and cl1 at 546, BUCK1 sat at 868750 uV (the max of both).
Cause: regulator voltage aggregation takes the maximum request of all consumers.
Evidence: measured under Lineage 2026-10-24. Consequence: two cpufreq-dt policies with cpu-supply = vdd_buck1 work via regulator aggregation. Scope: chunk 3c.
