id: learning_mainline_stage1_boot_t585_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792769206.534078
edges: [{"target_id": "domain_target_device_sm_t585_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_mainline_73_exynos7870_gap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_build_artifacts_not_in_tmp_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_flash_via_ncm_wget_unverified_2026_10_23", "edge_type": "related"}, {"target_id": "todo_emmc_hs200_vmmc_ldo26_2026_10_23", "edge_type": "related"}, {"target_id": "todo_test_touchscreen_stmfts_2026_10_23", "edge_type": "related"}, {"target_id": "todo_kernel_venv_pyusb_dtschema_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_flash_via_ncm_wget_verified_2026_10_23", "edge_type": "related"}, {"target_id": "domain_stage1_enable_modules_for_stmfts_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_poweroff_f_works_stage1_2026_10_23", "edge_type": "related"}]
cue: You are building or packaging a mainline boot image for the SM-T585, or S-Boot rejects or ignores your image or cmdline.
---

Observed: Mainline 7.3 stage-1 boot on SM-T585 works (2026-10-23) with the new board DTS src/mainline/arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts (passes dtbs_check). S-Boot accepts an Android boot header v0 image (page 2048, header_version slot = dt_size, kernel addr 0x10008000, ramdisk 0x11000000, tags 0x10000100, SEANDROIDENFORCE trailer) with a single DTBH entry (chip 7870, platform 0x50a6, subtype 0x217584da, hw_rev 0..0xff) and a text_offset=0 mainline kernel. The boot partition is 32 MiB: the defconfig kernel (32.6 MB) does not fit; the trimmed Exynos-only config is 19.1 MB. S-Boot replaces the kernel cmdline entirely (the boot.img cmdline is ignored). ramoops@0x46e00000 works. Working: 8 CPUs, 1.9 GB RAM (41 MB used idle), simpledrm fbcon, eMMC (25 MHz, HS200 not yet set), PMIC regulators, keys + hall, USB gadget (NCM/RNDIS/ACM). Build tooling in kernel/: gtaxllte-stage1.config, mkbootimg-gtaxllte.py (validated: reproduces the Lineage image's SHA1 id), build-stage1.sh, initramfs/init, tools/acm-shell.py, prebuilt busybox; persistent build dir kernel/build (built with LLVM=1 CC="ccache clang").
Cause: n/a (result of the first boot tests).
Evidence: src/mainline DTS, kernel/ tooling, boot test 2026-10-23.
