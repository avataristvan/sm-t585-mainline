id: learning_t585_opp_microvolt_triplet_shared_buck1_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792853977.225283
edges: [{"target_id": "learning_t585_clusters_share_buck1_regulator_aggregation_2026_10_24", "edge_type": "related"}]
cue: Writing opp-microvolt for two cpufreq-dt policies that share one regulator (BUCK1) and the cluster voltages look wrong.
---

Observed: With exact opp-microvolt (<v v v>) the two cpufreq-dt policies on the shared BUCK1 would have non-overlapping consumer ranges. The triplet <target target max>, with max = 1068750 (the highest OPP), makes the ranges overlap, and the regulator core takes the max of the mins. Verified on HW (kernel #25), BUCK1 uV by cluster freq (MHz): cl0 1248 / cl1 546 -> 868750; 342 / 1690 -> 1068750; 342 / 342 -> 600000; 1690 / 1690 -> 1068750.
Cause: each policy's request is a [min,max] range; with min=max the ranges of two clusters at different voltages cannot intersect, so one request fails. Widening max to the top voltage lets the aggregate be the highest min.
Evidence: measured on kernel #25 (BOOT sha1 c995c34a4d1f46c9ecf07e85667c1cd7c4679ed6) with kernel/out/st.sh. Refines learning_t585_clusters_share_buck1_regulator_aggregation_2026_10_24 (measured under Lineage, which did not show the range problem).
