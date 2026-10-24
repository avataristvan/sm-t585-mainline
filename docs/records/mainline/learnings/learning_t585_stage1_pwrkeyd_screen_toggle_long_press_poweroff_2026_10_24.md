id: learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792866501.575812
edges: [{"target_id": "learning_t585_poweroff_f_works_stage1_2026_10_23", "edge_type": "related"}, {"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}, {"target_id": "domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24", "edge_type": "related"}]
cue: You wonder what the power key does on stage 1, want the screen off, or hit that fb0/blank does nothing and the backlight stays on.
---

Observed: kernel/tools/pwrkeyd (nolibc, built by build-stage1.sh, started from initramfs/init) handles KEY_POWER from "GPIO Keys". A short press toggles the screen black, using an empty VT2 with the cursor hidden plus EVIOCGRAB on the stmfts touch device. Holding it for 2 s does sync + reboot(POWER_OFF). Verified on HW: black and back, touch grabbed (0 bytes vs 86904 bytes while not grabbed), long press powers off. The 2 s power-off fires before whatever made a long press reboot earlier (learning_t585_poweroff_f_works_stage1_2026_10_23; the PMIC manual reset as cause is doubtful, see learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24).
Cause: /sys/class/graphics/fb0/blank returns rc=0 with simpledrm but has no visible effect; a success return is not proof that the screen is dark, check with the user's eyes. The backlight stays on because brightness on the hx8279d is set via DSI commands (downstream hx8279d_lcd_ctrl.c), so a real display-off needs the DSI panel driver. The user chose "black screen, toggle with another press" for now.
Evidence: kernel/tools/pwrkeyd/, kernel/build-stage1.sh, kernel/initramfs/init; HW test 2026-10-24.
