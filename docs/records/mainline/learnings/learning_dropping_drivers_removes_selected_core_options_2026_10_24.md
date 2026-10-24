id: learning_dropping_drivers_removes_selected_core_options_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792831308.480544
edges: [{"target_id": "learning_defconfig_modules_pinned_builtin_2026_10_23", "edge_type": "related"}, {"target_id": "learning_trim_check_selected_subsystems_vanish_2026_10_24", "edge_type": "related"}]
cue: You disable drivers or trim the kernel config and it still builds, but core options (tmpfs, CMA, perf, thermal) may silently vanish.
---

Observed: In trim chunk 2, dropping drivers silently removed core options that only those drivers had selected: TMPFS (would have broken /tmp in the rootfs), CMA/DMA_CMA (CMA 32 MiB), PERF_EVENTS, ARM_PMU/PMUV3, and THERMAL/EXYNOS_THERMAL (stage1.config already says THERMAL off; it was only on via select, and no TMU was bound on the device). Also IPMI_HANDLER was misdetected as prompt-less and came back as =m.
Cause: Kconfig `select` chains: a core option can be =y only because a driver selects it. Disabling the driver turns the option off without any error.
Evidence: kernel/gtaxllte-builtin.config, session 2026-10-24. Method that caught it: diff the =y set of .config before/after the trim, filter out symbols named in the fragment, and pin whatever needed thing remains. Also check that the =m set is unchanged after each trim step.
