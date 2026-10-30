id: learning_t585_gpu_supply_is_buck2_shared_mif_int_disp_cam_not_buck3_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793377379.740752
edges: [{"target_id": "learning_t585_panfrost_probes_on_mainline_2026_10_24", "edge_type": "contradicts"}, {"target_id": "todo_t585_panfrost_mali_supply_opp_table_2026_10_24", "edge_type": "contradicts"}, {"target_id": "learning_t585_clusters_share_buck1_regulator_aggregation_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_gpu_pll_rate_table_and_devfreq_works_d1_d2_2026_10_30", "edge_type": "related"}]
cue: You wire mali-supply or GPU OPP voltages on the SM-T585, or touch any BUCK2/BUCK3 voltage.
---

Observed: The SM-T585 GPU (G3D) supply is BUCK2, not BUCK3. The downstream Mali driver does regulator_get(NULL, "BUCK2") in every r7p0..r29p0 gpu_exynos7870.c (Lineage config: CONFIG_MALI_DVFS=y, R29P0), and the downstream MIF, INT, DISP and CAM devfreq nodes in exynos7870.dtsi all use reg_name = "BUCK2". BUCK2 is therefore a shared MIF/INT/DISP/CAM/G3D rail. Mainline has no MIF/INT devfreq, and BUCK2 reads 775000 uV (set by the bootloader), so a GPU OPP table must keep a 775 mV floor, otherwise it would undervolt MIF/INT (DRAM, interconnect). The consumer of BUCK3 is unknown.
Cause: The earlier records took BUCK3 from the downstream DTS; the driver source and the devfreq nodes say BUCK2.
Evidence: src/downstream-lineage-21/drivers/gpu/arm/t83x/r29p0/platform/exynos/gpu_exynos7870.c:533; arch/arm64/boot/dts/exynos7870.dtsi devfreq_mif/int/disp/cam reg_name; docs/gpu-dvfs-plan-2026-10-30.md. Contradicts learning_t585_panfrost_probes_on_mainline_2026_10_24 and todo_t585_panfrost_mali_supply_opp_table_2026_10_24 (both name BUCK3). Same shared-rail pattern as learning_t585_clusters_share_buck1_regulator_aggregation_2026_10_24.
