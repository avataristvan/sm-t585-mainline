id: learning_t585_pmu_cpu_options_not_programmed_mainline_vs_downstream_syspwr_init_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793322709.706158
cue: You are debugging C2 hangs or any PMU-driven CPU power-down on the Exynos 7870 and wonder what downstream sets that mainline does not.
---

Observed: Downstream programs the PMU CPU options at boot (pwrcal/S5E7870/S5E7870-syspwr.c syspwr_init): CPUx_OPTION (0x2008 + n*0x80) |= USE_SMPEN b28, USE_STANDBYWFI b16, USE_MEMPWRDOWN_FEEDBACK b3, USE_SC_COUNTER b0, &= ~USE_STANDBYWFE b24, ~USE_SC_FEEDBACK b1; DURATION0; NONCPU_OPTION; L2_OPTION USE_STANDBYWFIL2; UP_SCHEDULER |= 3. Mainline does not. On the device cpu0 OPTION is 0x01010109 (STANDBYWFE on, SMPEN off) while cpu1-7 are 0x10010101 (MEMPWRDOWN_FEEDBACK off); L2_OPTION is 0, UP_SCHEDULER 0.
Cause: Hypothesis only: cpu0, the target of all SPIs, can be powered down at WFE or while coherent, which would explain the C2 interrupt loss.
Evidence: docs/cpuidle-plan-2026-10-29.md "Desk research after E7".
