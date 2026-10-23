id: learning_t585_lpass_is_not_exynos5433_lpass_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792773934.271719
edges: [{"target_id": "todo_audio_analysis_lpass_i2s_2026_10_23", "edge_type": "related"}, {"target_id": "domain_priority_audio_bt_dsi_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_t585_dispaud_reset_pulse_needed_2026_10_23", "edge_type": "related"}]
cue: You are starting SM-T585 audio bring-up and are about to reuse mainline drivers/mfd/exynos-lpass.c for the 7870 LPASS node.
---

Observed: The Exynos 7870 "LPASS" (downstream sound/soc/samsung/lpass-exynos7870.c, node lpass@148F0000) is NOT the Exynos5433 LPASS that mainline drivers/mfd/exynos-lpass.c handles: there is no CA5 core and the registers differ. On 7870 it is only DISPAUD_CFG at offset 0x1000 with SW reset bits 0=mixer, 1=MI2S, 2=AMP, 3=ADMA, plus the PMU pad-retention release (PMU 0x3028 bit 28, 0x1340 bit 0).
Cause: Same marketing name, different block; the 7870 only keeps reset and pad-retention control in it.
Why it matters: todo_audio_analysis_lpass_i2s_2026_10_23 and domain_priority_audio_bt_dsi_2026_10_23 assumed exynos-lpass.c as the basis ("likely an adaptation"); that assumption does not hold. Reset and pad release must be handled separately (DTS resets/syscon or a tiny driver).
Evidence: docs/audio-analysis-2026-10-23.md (code reading of the downstream tree, 2026-10-23).
