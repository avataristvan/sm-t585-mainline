id: learning_t585_dvfs_stress_60s_4200_transitions_ok_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792853977.851481
edges: [{"target_id": "learning_t585_cpu_numbering_cmu_and_cpuloop_tool_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24", "edge_type": "confirms"}]
cue: Wanting to trust the T585 cpufreq transitions enough to switch the default governor away from userspace.
---

Observed: DVFS stress kernel/out/dvfsstress.sh (8 cpuloop busy loops plus a random OPP per cluster via scaling_setspeed) ran 60 s with about 4200 transitions under full load: no hang, 39 -> 45 C. kernel/out/st.sh prints cluster freqs, BUCK1 uV, mux stat, PLL_CON0 and the MIF switch divider via memtool.
Cause: n/a (positive result); the transition sequence in domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24 holds under load.
Evidence: kernel #25 run, scripts kernel/out/dvfsstress.sh and kernel/out/st.sh; tool in learning_t585_cpu_numbering_cmu_and_cpuloop_tool_2026_10_24.
