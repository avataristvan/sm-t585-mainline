id: learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792867151.281704
edges: [{"target_id": "learning_t585_poweroff_f_works_stage1_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_pmic_2key_reset_verified_on_hw_2026_10_24", "edge_type": "related"}]
cue: You reason about why a long power-key press resets the SM-T585, or tune pwrkeyd long-press timing against the PMIC reset.
---

Observed: S2MPU05 registers on kernel #31 (i2c-0 0x66, read-only with i2cx): CTRL1 (0x0d) = 0x14, so MRSTB_EN = 1. CTRL3 (0x15) = 0x04, so bits 6..4 = 0 (MRSEL = 0, warm reset off). PWRONSRC (0x09) = 0x01. Downstream pmic_reset_enabled() writes exactly this combination in its "2-key reset, debug level LOW: manual reset" branch; its "1-key hard reset" branch sets MRSEL = 1. So Power alone probably does not reset the PMIC, Power + Vol-down does. Separately, the SM5703 has an MRSTB line (gpc7-4) that downstream drives high as "system alive, do not reset"; mainline leaves it as the bootloader set it.
Cause: The earlier claim that the PMIC manual reset makes a long Power press reboot (learning_t585_poweroff_f_works_stage1_2026_10_23) is not backed by these registers. This is inferred from downstream code names, there is no datasheet; it stays unproven until the PMIC reset test (hold only Power about 15 s with pwrkeyd stopped: reboot = 1-key, none = 2-key).
Evidence: i2cx register read on kernel #31; downstream drivers/regulator/s2mpu05.c:628-680, drivers/mfd/sm5703_core.c:441.
