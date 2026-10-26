id: learning_t585_gnome_mobile_power_button_backlight_2026_10_26
type: learning
area: device
perspective: agent
created: 1792973891.482993
edges: [{"target_id": "learning_t585_stage1_pwrkeyd_screen_toggle_long_press_poweroff_2026_10_24", "edge_type": "related"}, {"target_id": "domain_t585_pmos_ui_gnome_mobile_2026_10_26", "edge_type": "related"}, {"target_id": "todo_t585_dsi_decisions_after_hw_test_2026_10_26", "edge_type": "related"}]
cue: You configure the power button or screen-off on GNOME Mobile on the SM-T585, or wonder why the backlight stays on.
---

Observed: Under GNOME Mobile, gsd power-button-action defaulted to 'suspend' and sleep-inactive-battery-type to 'suspend' (900 s). The kernel offers only s2idle (/sys/power/mem_sleep shows [s2idle]), never tested on this device. gnome-shell-mobile has its own keybinding org.gnome.shell.keybindings power-button ['PowerOff']. The user set power-button-action to nothing; the screen then only goes black while the backlight stays on (simpledrm).
Cause: simpledrm has no DPMS/backlight. Downstream there is no separate backlight IC: hx8279d brightness is a DSI command (reg 0xB8, hx8279d_lcd_ctrl.c); panel power via LCD_1P8 regulator, gpio_buck_en gpd3-4, gpio_lcd_rst gpd4-1 (decon_board in exynos7870-gtaxl_common.dtsi). Real display-off needs the DSI panel driver (mainline panel-himax-hx8279 plus a new variant, exynosdrm DECON/DSIM).
Evidence: session 2026-10-26 on the device; downstream src/downstream-lineage-21 (hx8279d_lcd_ctrl.c, exynos7870-gtaxl_common.dtsi).
