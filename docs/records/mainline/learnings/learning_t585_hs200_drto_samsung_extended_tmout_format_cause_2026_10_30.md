id: learning_t585_hs200_drto_samsung_extended_tmout_format_cause_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793375792.104694
edges: [{"target_id": "learning_t585_hs200_data_reads_fail_mainline_2026_10_30", "edge_type": "supersedes"}]
cue: HS200 on an Exynos7870 (or other Samsung dw_mmc) tunes fine but every block read ends in a data read timeout (DRTO, RINTSTS 0x20c).
---

Observed: HS200 reads fail on the Exynos7870 dw_mmc although tuning passes (all-pass, PIO): every block read ends in DRTO (RINTSTS 0x20c). Logging RINTSTS/IDSTS per failing transfer distinguished DRTO from CRC/DMA errors and refuted the sampling-phase hypothesis.
Cause: The Exynos7870 controller uses Samsung's extended data-timeout format in TMOUT: (TMOUT[10:8]-1)*0xFFFFFF + TMOUT[31:11]*8 clocks. Downstream dw_mci_calc_timeout writes count<<11 | 7<<8 | 0xFF. Mainline wrote the plain format. At DDR52 the value 0x3D0900 happens to have [10:8]=1 (works by luck); at HS200 the value 0xf3fcf0ff has [10:8]=0, which gives a bogus short timeout.
Evidence: src/mainline 9e129452c (driver fix); docs/emmc-speed-plan-2026-10-30.md section "HS200 root cause and fix"; only the diagnostic "TMOUT max" flag made reads work (see pattern_t585_dwmmc_diag_kernel_runtime_flags_via_acm_shell_2026_10_30). Resolves the open hypotheses of learning_t585_hs200_data_reads_fail_mainline_2026_10_30.
