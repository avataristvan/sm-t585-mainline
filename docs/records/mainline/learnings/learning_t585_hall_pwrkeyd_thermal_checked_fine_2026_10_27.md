id: learning_t585_hall_pwrkeyd_thermal_checked_fine_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793003065.171247
edges: [{"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}]
cue: You wonder whether hall sensor, power key daemon, thermal, cpufreq or chassis type on the SM-T585 need standard-interface work.
---

Observed: audit found these already standard: the hall sensor is gpio-keys SW_LID with wakeup-source; thermal and cpufreq use the standard frameworks; chassis-type is tablet. pwrkeyd exists only in the stage-1 initramfs, not in pmOS (pmOS needs its own power-key handling).
Cause: n/a (no deviation found).
Evidence: read-only audit docs/standard-interfaces-audit-2026-10-27.md (code and records only, not run on HW).
