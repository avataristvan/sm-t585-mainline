id: learning_t585_poweroff_f_works_stage1_2026_10_23
type: learning
area: mainline
perspective: user
created: 1792778779.013298
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24", "edge_type": "related"}]
cue: You need to switch the SM-T585 off from the stage-1 Linux shell, or a long power-key press reboots it instead.
---

Observed: On stage 1 (mainline 7.3), `poweroff -f` from the shell switched the SM-T585 off (user confirmed, 2026-10-23 20:05). A long press of the power key was seen to reboot the device instead. Earlier on 2026-10-23 a plain `poweroff` (without -f) was reported to end in a reboot or hang; that was not retested after the -f result.
Cause: The reboot on long press was first attributed to the PMIC manual reset. The S2MPU05 registers do not back that for Power alone (see learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24); the cause is open. The power-off path that works is probably the syscon-poweroff handler (PS_HOLD) from the Exynos syscon restart DTSI, not verified against the board DTS or the downstream PS_HOLD offset.
Evidence: user test report 2026-10-23 20:05 (stage-1 shell, `poweroff -f`); no source file.
