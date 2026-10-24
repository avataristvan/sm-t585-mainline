id: learning_t585_max8973_comes_from_defconfig_depends_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792849365.672399
edges: [{"target_id": "learning_t585_exynos_thermal_selects_max8973_2026_10_24", "edge_type": "supersedes"}]
cue: REGULATOR_MAX8973 reappears in .config after enabling THERMAL, or you wonder whether a Kconfig option can be pinned off.
---

Observed: EXYNOS_THERMAL does NOT select REGULATOR_MAX8973 (this corrects learning_t585_exynos_thermal_selects_max8973_2026_10_24). Arm64 defconfig sets CONFIG_REGULATOR_MAX8973=y and the driver `depends on THERMAL && THERMAL_OF`, so it came back only because THERMAL was re-enabled. Fix: "# CONFIG_REGULATOR_MAX8973 is not set" in kernel/gtaxllte-stage1.config next to the other foreign regulators; .config confirms it is off.
Cause: A `select` cannot be pinned off, a `depends on` can; telling them apart decided whether pinning works.
Evidence: thermal chunk 2, 2026-10-24, kernel #21 on hardware.
