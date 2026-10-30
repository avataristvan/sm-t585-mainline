id: domain_t585_emmc_ddr52_clock_frequency_cap_highspeed_2026_10_30
type: domain
area: mainline
perspective: agent
created: 1793346588.235783
cue: You tune eMMC speed in the SM-T585 board DTS, or wonder why the eMMC reads at 25 MHz or caps near 50 MHz.
---

Decision: The board DTS mmc0 carries `cap-mmc-highspeed` and `clock-frequency = <800000000>`; the eMMC runs DDR52 (src/mainline dfe2dfcd4, package linux-samsung-gtaxllte r14). Read speed 20.8 -> 72.7 MB/s.
Why: Without clock-frequency the CIU clock stays at 199.875 MHz, which caps bus_hz at about 50 MHz. Without cap-mmc-highspeed the card stays in legacy 25 MHz. dw_mmc-exynos gives all hosts MMC_CAP_1_8V_DDR (caps index 0), so HS52 becomes DDR52. Precedents: Exynos7 espresso, 7885 jackpotlte, 850 boards. Verified: p19 sha256 equal to the 25 MHz baseline, load, s2idle, 3 reboots.
Scope: SM-T585 mmc0 in mainline. HS200/HS400 is a separate, failing matter (see the HS200 learning).
Evidence: docs/emmc-speed-plan-2026-10-30.md, src/mainline dfe2dfcd4
