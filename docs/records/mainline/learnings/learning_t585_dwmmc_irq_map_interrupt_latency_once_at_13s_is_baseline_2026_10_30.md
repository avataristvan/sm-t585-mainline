id: learning_t585_dwmmc_irq_map_interrupt_latency_once_at_13s_is_baseline_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793341580.585985
edges: [{"target_id": "learning_t585_cpuidle_c2_loses_device_irqs_under_io_2026_10_30", "edge_type": "contradicts"}]
cue: You read dw_mmc "Interrupt latency" warnings in dmesg while judging an idle or power experiment on the SM-T585.
---

Observed: Correction: the r11 "Interrupt latency" endless loop was on 13550000.mmc = mmc1 = WiFi SDIO (IRQ 45), not the eMMC. IRQ map: 47 = 13540000 mmc0 eMMC, 45 = 13550000 mmc1 SDIO WiFi, 46 = 13560000 mmc2 SD. A single "dwmmc_exynos 13540000.mmc: Interrupt latency, state 1" at ~13.6 s of boot (right after the exynos-drm deferred probe timeout) also occurs without cpuidle (r12 boot, 6 of 84 older boots).
Cause: That single warning is a baseline artefact, not a C2 symptom; only loops or hangs count.
Evidence: journalctl over 84 boots; /sys/class/mmc_host mapping.
