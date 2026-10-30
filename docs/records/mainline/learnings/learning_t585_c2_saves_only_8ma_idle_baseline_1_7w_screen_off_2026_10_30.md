id: learning_t585_c2_saves_only_8ma_idle_baseline_1_7w_screen_off_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793317613.22032
edges: [{"target_id": "learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30", "edge_type": "related"}, {"target_id": "pattern_t585_on_device_measurement_scripts_systemd_run_usb_unplugged_2026_10_30", "edge_type": "related"}]
cue: You expect cpuidle C2 to cut idle power on the SM-T585, or you hunt for why the battery drains with the screen off.
---

Observed: C2 (core-only power-down) saves only ~8 mA (~2 %, within noise) at idle with screen off (gdm inactive), WiFi on, USB unplugged: C2 disabled 425 mA (sd 36) / 427 mA (sd 38), enabled 417 mA (sd 25), at ~4.05 V, i.e. ~1.7 W.
Cause: C2 powers down only the cores; L2/non-CPU domains and the SoC stay on (cluster power-down CPD and SICD are not implemented). The real power topic is the ~1.7 W screen-off idle baseline. Candidates: WiFi active mode, panel/DSI supplies after blank, always-on regulators.
Evidence: docs/cpuidle-plan-2026-10-29.md, section "E6 result"; siblings learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30.
