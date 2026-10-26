id: learning_t585_dsi_panel_boe2_params_supplies_timings_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1792976190.049844
edges: [{"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "derived_from"}, {"target_id": "learning_t585_downstream_kernel_source_and_roms_2026_10_23", "edge_type": "derived_from"}]
cue: You need the SM-T585 panel facts: init table, brightness register, supplies, reset GPIO or timings.
---

Observed: Panel id 0x827903 selects the downstream "BOE2" init table (BOE 8.5" for T58X). Brightness is DSI register 0xB8 on page 4, UI 0..255 mapped linearly to 0..199, default 117; there is no backlight IC and no i2c part. Supplies: iovcc = LDO35 (LCD_1P8), vdd = fixed regulator on gpd3-4, reset = gpd4-1 active low. Timings 1200x1920, hbp 32 / hfp 120 / hsa 8, vbp 16 / vfp 16 / vsa 4, pixel clock 159.6 MHz, DSI burst 980 MHz, 4 lanes.
Cause: Values taken from the downstream gtaxllte kernel/DT; not yet verified on hardware.
Evidence: src/downstream-lineage-21 (gtaxllte DTS and panel driver); learning_t585_downstream_kernel_source_and_roms_2026_10_23 for the source.
