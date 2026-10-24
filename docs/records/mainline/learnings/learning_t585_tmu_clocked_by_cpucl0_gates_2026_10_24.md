id: learning_t585_tmu_clocked_by_cpucl0_gates_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792848642.800313
edges: [{"target_id": "domain_t585_cmu_cpucl_readonly_in_mainline_fork_2026_10_24", "edge_type": "related"}]
cue: The TMU probes fine but the first temperature read panics with a synchronous external abort after ~0.5 s of boot.
---

Observed: The 7870 TMU register block at 0x10130000 is clocked by the CPUCL0 gate pair (CLK_GOUT_PERI_SFRIF_TMU_CPUCL0_PCLK as tmu_apbif, CLK_GOUT_PERI_TMU_CPUCL0_CLK as tmu_sclk), NOT by the unsuffixed SFRIF_TMU_PCLK/TMU_CLK (that pair is the G3D one in downstream naming). With the wrong pair, probe works (bootloader leaves all gates on) but after clk_disable_unused (~0.5 s) the first temperature read gives a synchronous external abort -> panic (kernel #15, pstore).
Cause: wrong gate pair in the DT, so the real TMU gate was disabled as unused. Downstream never disables any of the three TMU gate groups (vclk_disable commented out in pwrcal S5E7870-vclk.c). The readw->readl change tried along the way was NOT needed (readw tested OK).
Evidence: With CLK_IGNORE_UNUSED on all six gates, reads worked even while sfrif_tmu_pclk was off in hardware; with the CPUCL0 pair in DT and no hack it works and clk_summary shows only the CPUCL0 gates used. Kernel #15 pstore. Scope: exynos7870 dtsi / clocks.
