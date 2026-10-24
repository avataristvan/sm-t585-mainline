id: domain_kernel_trim_chunk3_defconfig_ballast_off_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792832533.494677
edges: [{"target_id": "domain_kernel_trim_chunk2_builtin_pins_by_reason_2026_10_24", "edge_type": "related"}, {"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "derived_from"}]
cue: You wonder why the kernel image lacks EFI, Xen, other-SoC drivers, or want to re-add a bus or subsystem the arm64 defconfig had on.
---

Decision: Trim chunk 3 turns off defconfig =y ballast: of 828 defconfig =y options only 279 were still active after the ARCH_* trim, and 128 of them are set "# ... is not set" in a commented block at the end of kernel/gtaxllte-stage1.config. Groups: Xen/virtio/VFIO; EFI (incl. EFI stub), SCMI, OP-TEE/TEE, TPM, coreboot, remoteproc; other-SoC IOMMU (ARM SMMU), DMA, PL011/8250/FSL/Xilinx serial, SDHCI/other MMC, SPI, I2C, GPIO, USB controllers (ChipIdea, DWC2, EHCI/OHCI, MUSB, ISP1760); other-board PMICs/regulators/clocks/RTCs/watchdogs/CrOS EC, PHY_SAMSUNG_UFS, DRM_EXYNOS_HDMI, CEC; memory hotplug/failure, hugetlbfs.
Kept on purpose: Exynos DECON/DSI/MIC (for the DSI panel chunk), PL330, S3C I2C/SPI/watchdog/RTC, XHCI + NOP xceiv (dwc3 host), all USB gadget functions, SERIAL_DEV_BUS (Bluetooth hci_uart later), PWM_SAMSUNG, generic LED/regulator/I2C mux, fs/cgroup/net core, DEBUG_FS, IKCONFIG.
Why: Image 16.1 -> 13.3 MB (19.7 MB before chunk 1), boot.img 14.7 MB, far from the 32 MiB BOOT limit. EFI stub is not needed: S-Boot boots the raw Image (verified). regmap-spi became =m (only a sound module needs it), 29 modules.
Scope: Verified on hardware 2026-10-24 (kernel #14, BOOT sha1 946622c1e22c2d508779ba881c4ac9d50e07e731, user flashed): boots, sound card + capture/playback, stmfts, jack, fb0, CMA 32 MiB, 30 regulators; set of bound drivers identical to before except the legacy serial8250 stub (intended). Re-enable a group deliberately when a later chunk needs it (DSI panel, Bluetooth, thermal).
