id: learning_mainline_73_exynos7870_gap_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792769193.121409
edges: [{"target_id": "learning_t585_downstream_kernel_source_and_roms_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stmfts_fts1a096_not_command_compatible_2026_10_23", "edge_type": "contradicts"}, {"target_id": "learning_gap_survey_compatible_is_hypothesis_2026_10_23", "edge_type": "contradicts"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}]
cue: You are deciding what driver work the SM-T585 needs on mainline, or whether reverse engineering binaries is required.
---

Observed: Mainline Linux 7.3 contains Exynos7870 support (exynos7870.dtsi; boards a2corelte, j5y17lte, j6lte, j7xelte, on7xelte) covering CPU, CMUs, pinctrl, UART, I2C/HSI2C, DW-MMC, USB DRD (dwc3), DECON + MIPI-DSI, Mali-T830 (panfrost), SysMMU. Missing upstream for this board: SoC audio (I2S/LPASS), SM5703 charger/fuel gauge (only a regulator binding exists), TMU/cpufreq, SX9306 grip, camera. Board chips with existing mainline drivers: S2MPU05 PMIC, HX8279 panel driver (needs a new panel variant), STM FTS1A096 touch (stmfts, same command set), QCA9377 SDIO WiFi (ath10k_sdio, needs ath10k-format firmware), RT5659 codec, K2HH = LIS2HH12 accel, CM3323 light. Reverse engineering of binaries is not needed (GPL source + mainline).
Cause: n/a (survey).
Evidence: device-dump/sm-t585/mainline-gap.md; clone in src/mainline.
