id: learning_t585_bootloader_fb_a8r8g8b8_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792769207.606139
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_unused_regulator_cleanup_vdd_fixed_lcd_always_on_2026_10_26", "edge_type": "related"}]
cue: You are configuring simpledrm/framebuffer colors on the SM-T585 or worry about the red/blue swap seen in the old pmOS port.
---

Observed: On mainline, the SM-T585 bootloader framebuffer at 0x67000000 is a8r8g8b8, 1200x1920, stride 4800; colors were verified correct on the device. The R/B swap known from the old pmOS port does not occur on mainline.
Cause: the swap belonged to the old downstream setup.
Evidence: boot test 2026-10-23 (learning_mainline_stage1_boot_t585_2026_10_23).
