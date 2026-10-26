id: learning_t585_pmic_2key_reset_verified_on_hw_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792875052.133402
edges: [{"target_id": "learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24", "edge_type": "confirms"}, {"target_id": "learning_t585_rootfs_image_made_on_device_no_usb_copy_2026_10_25", "edge_type": "related"}]
cue: You need to hard-reset the SM-T585 without the kernel, or wonder whether holding Power alone reboots the tablet.
---

Observed: On hardware, kernel #31, with pwrkeyd stopped: holding only Power for about 15 s did nothing (uptime kept counting). Holding Power + Vol-down for about 15 s rebooted the device. The S2MPU05 registers (CTRL1 0x14, MRSTB_EN = 1; CTRL3 0x04, MRSEL = 0) predicted this 2-key manual reset.
Cause: The PMIC manual reset is reached with Power + Vol-down; Power alone does not trigger it. So a hard reset path exists independent of the kernel, and holding Power alone is safe (pwrkeyd powers off on a 2 s hold). This closes the test left open in learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24 (step 1 of todo_t585_pmic_reset_test_numbered_images_flash_panfrost_2026_10_24).
Evidence: Hardware test 2026-10-24 on kernel #31 (kernel/out/boot-stage1-k31.img); learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24.
