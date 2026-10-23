id: learning_t585_dispaud_reset_pulse_needed_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792778219.489693
edges: [{"target_id": "learning_t585_lpass_is_not_exynos5433_lpass_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_s1402x_mixer_driver_works_2026_10_23", "edge_type": "related"}]
cue: SM-T585 ADMA or MI2S is dead although clocks and registers look fine and DISPAUD_CFG reset bits read 0.
---

Observed: DISPAUD_CFG (0x148F1000) audio soft resets (bit0 mixer, 1 MI2S, 2 AMP, 3 ADMA; active high) read 0 after boot, yet ADMA and MI2S are unusable until the reset is pulsed (downstream amba/bus.c and lpass_enable do this). Implemented as reset-simple compatible `samsung,exynos7870-dispaud-reset` plus local pulse patches in pl330.c and i2s.c. PMU pad retention (0x3028 bit 28) is already clear; no pad code was needed so far.
Cause: A reset bit reading 0 does not mean the block is out of a usable reset state; the pulse is what initialises it.
Evidence: docs/handoff-2026-10-23.md, section "Update 2026-10-23 evening"; downstream amba/bus.c and lpass_enable.
Refines learning_t585_lpass_is_not_exynos5433_lpass_2026_10_23 (pad-retention part not needed).
