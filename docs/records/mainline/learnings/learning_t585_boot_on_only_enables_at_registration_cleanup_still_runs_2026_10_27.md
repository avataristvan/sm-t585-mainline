id: learning_t585_boot_on_only_enables_at_registration_cleanup_still_runs_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793001886.274145
edges: [{"target_id": "learning_t585_unused_regulator_cleanup_vdd_fixed_lcd_always_on_2026_10_26", "edge_type": "related"}]
cue: You drop or keep regulator-boot-on or regulator-always-on on a panel rail and wonder what keeps it powered after the late cleanup.
---

Observed: In the regulator core, regulator-boot-on only enables the rail at registration; it does not stop the late unused-regulator cleanup (about 30 s after init) from disabling a rail that has no consumer. For regulator-fixed, boot-on also sets the initial GPIO high, so dropping boot-on would drive the panel buck GPIO low at probe. The switchable panel-power test variant therefore removes only regulator-always-on and keeps boot-on.
Cause: Cleanup disables every enabled regulator without consumer unless it is always-on; boot-on is only an initial-state hint.
Evidence: Extends learning_t585_unused_regulator_cleanup_vdd_fixed_lcd_always_on_2026_10_26 (reasoning from the regulator core, untested on HW 2026-10-27); board DTS exynos7870-gtaxllte.dts (vdd_fixed_lcd, ldo35).
