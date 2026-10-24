id: learning_t585_cpufreq_dt_first_transition_undervolt_fix_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792853977.437176
edges: [{"target_id": "learning_t585_opp_microvolt_triplet_shared_buck1_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_sboot_leaves_cpu_clusters_902mhz_clk_summary_2026_10_24", "edge_type": "related"}]
cue: Bringing up cpufreq-dt with several policies on one shared supply and one cluster is still at its boot rate while another switches.
---

Observed: A cpufreq-dt policy registers its regulator request only on its first transition. The first switch of cluster 1 (902 -> 838 MHz) dropped BUCK1 to 712500 uV while cluster 0 still ran 902.2 MHz from S-Boot (needs 737500) -> undervolt.
Cause: no request from cluster 0 existed yet, so the aggregate followed cluster 1 alone.
Fix (in the fork, drivers/cpufreq/cpufreq-dt.c, dt_cpufreq_early_init): when a supply exists, call dev_pm_opp_set_rate(cpu_dev, clk_get_rate(cpu clk)) once, before the driver registers, so every CPU group's voltage request is in place. Verified on kernel #25: cl1 at 342.875 MHz keeps BUCK1 at 737500 uV with cl0 at 902.2 MHz.
Evidence: HW test on kernel #25 (BOOT sha1 c995c34a4d1f46c9ecf07e85667c1cd7c4679ed6); S-Boot rate in learning_t585_sboot_leaves_cpu_clusters_902mhz_clk_summary_2026_10_24.
