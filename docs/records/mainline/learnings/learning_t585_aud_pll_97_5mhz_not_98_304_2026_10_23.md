id: learning_t585_aud_pll_97_5mhz_not_98_304_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792778219.67309
superseded_by: learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23
valid_until: 1792784296.957327
cue: You are checking SM-T585 audio sample rates or wondering why 48 kHz playback runs about 0.8 percent off.
---

Observed: AUD_PLL runs at 97.5 MHz under mainline, not 98.304 MHz, so 48 kHz audio is off by about 0.8 %.
Cause: No PLL rate table entry for 98.304 MHz in the mainline clock driver.
Evidence: docs/handoff-2026-10-23.md, section "Update 2026-10-23 evening". Follow-up: add a PLL rate table entry (todo).
