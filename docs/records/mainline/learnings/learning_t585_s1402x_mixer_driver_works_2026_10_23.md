id: learning_t585_s1402x_mixer_driver_works_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792785320.602025
edges: [{"target_id": "learning_t585_dispaud_reset_pulse_needed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "related"}]
cue: You need to confirm the SM-T585 audio mixer (s1402x) is probed and configured, or wonder how to read its registers.
---

Observed: The local s1402x mixer driver works: src/mainline/sound/soc/samsung/s1402x-mixer.c (module snd-soc-s1402x-mixer, compatible samsung,exynos7870-s1402x, node audio-mixer@14880000 with clocks apb=GOUT_DISPAUD_APB_AUD, sysclk=GOUT_DISPAUD_MIXER_AUD_SYSCLK, resets=<&dispaud_reset 0>, pins gpz1-0..3 func2 pull-up drv FAST_SR3). After probe all init registers read back as expected via regmap debugfs (/sys/kernel/debug/regmap/14880000.audio-mixer/registers; mount debugfs first): SOFT_RSTB 3, IN1_CTL2 0, HQ_CTL 4, SLOT 1/2, TSLOT 1, DIG_EN 8, INAMP 0x2a.
Cause: n/a (positive result; the sysclk rate needed the +100 Hz trick, see the sibling record).
Evidence: hardware check, kernel #8, 2026-10-23 (audio chunk 3a).
