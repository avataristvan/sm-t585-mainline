id: learning_t585_jack_detect_gpa0_5_active_low_verified_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792827873.047995
edges: [{"target_id": "learning_t585_loose_plug_looks_like_dead_headset_mic_2026_10_24", "edge_type": "related"}]
cue: You are wiring SM-T585 headset jack detection and need the polarity, pull and pinctrl of the detect GPIO (gpa0-5).
---

Observed: SM-T585 jack detect is gpa0-5, verified on mainline stage 1 with /tmp/memtool on GPA0 DAT (0x139f0044, bit 5): plugged = 0, unplugged = 1, so active-low with an external pull-up. The pin's reset state is input with pull-down (PUD 0x139f0048 bits 11:10 = 01); downstream uses EINT + pull none. The key line gpa1-4 reads 0 regardless of plug (tested without mic bias, not judged).
Cause: board wiring (external pull-up on the detect line).
Correction: the earlier FOCUS claim that debugfs gpio showed gpa0-5 "in hi IRQ" was wrong; an unclaimed pin is not listed there (that entry was gpio-4 = stmfts).
Evidence: hardware reads 2026-10-24 via memtool (kernel/tools/memtool).
