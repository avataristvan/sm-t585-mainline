id: learning_t585_panfrost_probes_on_mainline_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792875769.923356
edges: [{"target_id": "domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24", "edge_type": "related"}, {"target_id": "todo_t585_panfrost_mali_supply_opp_table_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_pmos_edge_boots_verified_over_usb_ssh_2026_10_25", "edge_type": "related"}]
cue: You enable Panfrost on the SM-T585 mainline kernel and wonder whether the GPU works without a power-domain driver or a regulator.
---

Observed: On the SM-T585 mainline stage 1, Panfrost probes with only `&gpu { status = "okay"; }` added to exynos7870-gtaxllte.dts. exynos7870.dtsi already has the gpu@11400000 node, and CONFIG_DRM_PANFROST=y was already in kernel/gtaxllte-builtin.config. dmesg: "mali-t830 id 0x830 major 0x0 minor 0x1", shader_present=0x1, clocks at 343 MHz, "Initialized panfrost 1.6.0", /dev/dri/renderD128 exists. No hang. The warning "supply mali not found, using dummy regulator" appears.
Cause (hypothesis, not checked): Mainline has no G3D power-domain driver, yet there is no hang; presumably S-Boot leaves pd_g3d on. The GPU rail is a dummy regulator: the downstream DTS supplies G3D from BUCK3 (always on, 0.5-1.3 V), and that is not wired as mali-supply or as an OPP table yet (todo_t585_panfrost_mali_supply_opp_table_2026_10_24).
Evidence: dmesg of the boot of kernel/out/boot-stage1-k32b.img (sha1 95827e2a87df4854d96b910be7a2f93fcbaa022f, on BOOT), 2026-10-24. Rendering works on the same kernel: kmscube on Panfrost, see learning_t585_panfrost_renders_kmscube_simpledrm_2026_10_24.
