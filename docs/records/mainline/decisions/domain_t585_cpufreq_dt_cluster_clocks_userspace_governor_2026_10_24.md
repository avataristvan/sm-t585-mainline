id: domain_t585_cpufreq_dt_cluster_clocks_userspace_governor_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792853990.839003
edges: [{"target_id": "learning_t585_opp_microvolt_triplet_shared_buck1_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_cpufreq_dt_first_transition_undervolt_fix_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_cpu_opp_table_asv7_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "derived_from"}, {"target_id": "learning_t585_cpucl_pll_14170_rates_dividers_cmu_missing_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_thermal_followup_trips_cpufreq_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_cooling_maps_both_clusters_2026_10_24", "edge_type": "related"}]
cue: Changing T585 cpufreq: clock layout, transition order, OPP/supply wiring, or the default governor (now schedutil).
---

Decision: T585 cpufreq = cpufreq-dt on new cluster clocks CLK_CLUSTER0/1_SCLK (clk-cpu.c, CPUCLK_LAYOUT_E7870, modelled on the Exynos850 layout).
- Parent mout_cpuclx_pll (MUX_F with CLK_SET_RATE_PARENT) -> fout_cpuclx_pll, rates from the ECT table cpucl_pll_rates (14 rates, 342.875..1690 MHz). Alternate parent mout_cpuclx_switch_user, set to the MIF CPUCLx_SWITCH via assigned-clock-parents in the dtsi.
- Transition: lower the MIF switch divider so the alt rate <= min(old,new); flip MUX_CPUCLx (0x208 bit 12, wait one-hot stat 0x608 bits 12-13); set the HPM divider (0x420, the only divider that varies per ECT); relock the PLL; flip back; alt back to max.
- OPP tables per cluster in the BOARD dts (voltages are this chip's ASV), opp-microvolt <v v 1068750>, cpu-supply = vdd_buck1 on all 8 cpus, clocks in the dtsi cpu nodes.
- Config: CPU_FREQ pin removed from gtaxllte-stage1.config; cpufreq block in gtaxllte-builtin.config (CPUFREQ_DT, PLATDEV, STAT, governors, CPU_THERMAL); CPU_FREQ_GOV_CONSERVATIVE pinned off (defconfig =m).
- Default governor: SCHEDUTIL (CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y in gtaxllte-builtin.config) since thermal chunk 3d, kernel #26. It was USERSPACE during bring-up (the id still says userspace).
Why: the ECT PLL needs a glitch-free alternate parent while it relocks; modelling on Exynos850 reuses the existing cpu-clock code. Userspace was the bring-up default because a failing transition at boot would otherwise boot-loop and need TWRP. Switched to schedutil after the boot-OPP fix and BUCK1 aggregation were verified in 3c: kernel #26 booted fine with schedutil on both policies, a 60 s + 180 s 8-core load ran at 1690 MHz without hang, idle drops to 342.875 MHz. The triplet and the early set_rate are required for the shared BUCK1 (see the two learnings).
Scope: thermal chunk 3c DONE 2026-10-24 (kernel #25, BOOT sha1 c995c34a4d1f46c9ecf07e85667c1cd7c4679ed6; #22 kept as kernel/out/boot-stage1-k22.img, #21 as boot-stage1-k21.img), stress-tested (dvfs learning); governor switch and cooling maps in 3d, kernel #26 (see domain_t585_cooling_maps_both_clusters_2026_10_24).
