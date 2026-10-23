id: learning_t585_pmu_aud_sys_pwr_alone_gives_no_sound_2026_10_23
type: learning
area: mainline
perspective: the-coder
created: 1792786743.813294
edges: [{"target_id": "learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23", "edge_type": "related"}]
cue: SM-T585 audio is silent and you wonder whether PMU power bits (GPIO_MODE_AUD_SYS_PWR, mixer reg-alive) are the cause.
---

Observed: PMU 0x10481340 (GPIO_MODE_AUD_SYS_PWR) reads 0 on mainline; setting bit0 alone did not produce sound. PMU 0x10480080 bit0 = 0 (mixer reg-alive, active-low) already on mainline.
Cause: Not the cause of the silence; the missing mixer routing was (see learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23, fix unverified).
Evidence: hardware test 2026-10-23 (audio chunk 3c).
