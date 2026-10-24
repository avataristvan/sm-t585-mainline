id: learning_t585_exynos_thermal_selects_max8973_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792848643.381542
superseded_by: learning_t585_max8973_comes_from_defconfig_depends_2026_10_24
valid_until: 1792849365.875023
edges: [{"target_id": "learning_kernel_venv_ready_dtbs_check_audio_warnings_2026_10_24", "edge_type": "related"}]
cue: Trimming the kernel config or tidying thermal Kconfig deps and wondering why REGULATOR_MAX8973 is on; or dtbs_check setup.
---

Observed: EXYNOS_THERMAL selects REGULATOR_MAX8973 (dead weight on this board); candidate to pin off in a later thermal chunk. Also: dtschema now installs into a venv and dtbs_check runs; remaining warnings are audio-only.
Cause: Kconfig select in the Exynos thermal driver.
Evidence: thermal chunk 1 session 2026-10-24; relates to todo_kernel_venv_pyusb_dtschema_2026_10_23.
