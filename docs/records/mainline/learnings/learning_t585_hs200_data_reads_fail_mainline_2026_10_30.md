id: learning_t585_hs200_data_reads_fail_mainline_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793346588.489185
edges: [{"target_id": "domain_t585_emmc_ddr52_clock_frequency_cap_highspeed_2026_10_30", "edge_type": "related"}, {"target_id": "learning_t585_uboot_emmc_flaky_reads_hs400_2026_10_26", "edge_type": "related"}]
cue: You try HS200 or HS400 on the SM-T585 eMMC in the kernel and card init and tuning succeed but the rootfs cannot be read.
---

Observed: HS200 on the 7870 in mainline fails beyond DT. Card init and tuning succeed ("new HS200 MMC card", 199.875 MHz) but every data read fails from sector 0 (I/O error, endless reset/re-init), so no rootfs. A live sweep of CLKSEL64 (0x135400A8) sample 0-7 x drive 4/3/2 with 4 KiB O_DIRECT reads: all fail, and the reads reach the controller.
Cause: Not a sample/drive phase problem. Open hypotheses (driver work): downstream-only 200 MHz setup (use-fine-tuning/enable-shift, bypass-for-allpass, ignore-phase, enable-ulp-mode, card-init-hwacg-ctrl), or the IDMAC data path at 200 MHz (tuning's 128 B transfer runs PIO below dma_threshold 512). TWRP's downstream kernel has no /dev/mem and no debugfs ios, so its registers cannot be dumped there.
Evidence: docs/emmc-speed-plan-2026-10-30.md (Results)
