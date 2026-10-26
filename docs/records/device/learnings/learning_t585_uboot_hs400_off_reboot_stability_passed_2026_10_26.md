id: learning_t585_uboot_hs400_off_reboot_stability_passed_2026_10_26
type: learning
area: device
perspective: user
created: 1792974072.078216
edges: [{"target_id": "learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26", "edge_type": "confirms"}]
cue: Doubting whether the HS200/HS400-off U-Boot on the SM-T585 boots reliably, or about to re-enable eMMC HS200/HS400 in U-Boot.
---

Observed: The HS200/HS400-off U-Boot build (uboot/gtaxllte.config, image sha1 a61dbe31...) passed the multi-reboot stability test on the SM-T585. Several reboots without keys; each boot reached GNOME Mobile via U-Boot -> systemd-boot -> kernel. Tablet was on the wall charger.
Cause: Disabling HS400/HS400_ES/HS200 (DDR52 max) removes the flaky GPT reads, as the earlier hypothesis suggested (the board timings for HS400 are still unverified, so the exact root cause remains open).
Evidence: Verified by the user on hardware, 2026-10-26. Confirms learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26.
