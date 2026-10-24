id: domain_kernel_trim_chunk2_builtin_pins_by_reason_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792831299.114203
edges: [{"target_id": "domain_kernel_trim_chunk1_foreign_sound_disabled_2026_10_24", "edge_type": "related"}, {"target_id": "learning_dropping_drivers_removes_selected_core_options_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_kernel_trim_chunk3_defconfig_ballast_off_2026_10_24", "edge_type": "related"}]
cue: You wonder why a driver is pinned =y or "not set" in gtaxllte-builtin.config, or you plan the next kernel trim chunk or the thermal chunk.
---

Decision: Trim chunk 2 (2026-10-24, verified on hardware): kernel/gtaxllte-builtin.config rewritten from 382 blind =y pins into 63 =y grouped by reason, plus 258 "# is not set". Groups: this SoC (DRM_EXYNOS, DRM_SAMSUNG_DSIM, DRM_PANFROST, DEVFREQ_GOV_SIMPLE_ONDEMAND, PHY_EXYNOS5_USBDRD); USB OTG peripherals (ACM, serial cp210x/ftdi/option, all USB net adapters, HID_MULTITOUCH, FF_MEMLESS, PHYLIB); networking stack (VLAN, MACVLAN/MACVTAP, VETH, HSR, 9P(+FD), NBD, WWAN); software crypto; generic (dma-buf heaps, DM, spidev, i2c-gpio, reset-gpio); and a dedicated group of core options that drivers had only selected (TMPFS, CMA/DMA_CMA, PERF_EVENTS, ARM_PMU/PMUV3). "Not set": other SoCs/boards, coresight/STM/PMUs of other cores, TypeC, Xilinx/FPGA, CrOS, IPMI, TPM, foreign RTC/PMIC/charger/touch/LED, Ethernet PHYs, NET_9P_VIRTIO. 56 prompt-less helper symbols were removed from the file (selects pull them); Ethernet PHYs needed by kept USB adapters (AX88796B, MICROCHIP, SMSC, FIXED) come via select and are not listed.
Why: Blind pins were ballast for other SoCs. Result: Image 19.7 -> 16.1 MB, boot.img 21.1 -> 17.6 MB, still 28 modules. Kernel #13, BOOT sha1 2d0699da2e77cec88038080f4cbc501612db88b4 (user flashed). Verified: boots, SMT585 card + capture/playback, stmfts, headset jack input, simpledrm fb0, CMA reserved. See learning_dropping_drivers_removes_selected_core_options_2026_10_24 for the pitfall.
Scope: kernel/gtaxllte-builtin.config. Next trim chunk: ballast among the ~1820 options already =y in arm64 defconfig. The thermal chunk (priority: domain_priority_thermal_battery_before_bt_2026_10_24) must re-enable THERMAL + EXYNOS_THERMAL deliberately, as they are now off.
