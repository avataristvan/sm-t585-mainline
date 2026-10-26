id: learning_t585_dtbs_check_clean_local_bindings_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792862896.867481
edges: [{"target_id": "learning_kernel_venv_ready_dtbs_check_audio_warnings_2026_10_24", "edge_type": "supersedes"}, {"target_id": "domain_t585_adc_vdd_supply_ldo3_2026_10_24", "edge_type": "related"}, {"target_id": "learning_rt5659_driver_gpio_names_unprefixed_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_dtbtool_needs_model_info_props_fdtput_2026_10_25", "edge_type": "related"}]
cue: You run dtbs_check on gtaxllte, wonder if it is clean, or touch the audio bindings (rt5659, s1402x, i2s, dispaud-reset).
---

Observed: dtbs_check of exynos7870-gtaxllte.dtb is clean (2026-10-24) after local binding work in our fork. New schemas: reset/samsung,exynos7870-dispaud-reset.yaml, sound/samsung,exynos7870-s1402x.yaml, sound/samsung,gtaxllte-audio.yaml. samsung-i2s.yaml now allows `resets`. realtek,rt5659.yaml: `interrupts` is no longer required (the driver handles a missing IRQ, and jack detection here is GPIO-only); it adds in1/in3/in4-differential, ldo1-en-gpios and reset-gpios, the names the driver actually reads. The realtek,-prefixed GPIO names are marked deprecated because the driver never reads them.
Cause: The user ordered the warnings fixed; upstreaming is not pursued, so the schemas only need to satisfy our fork. Scope: src/mainline branch gtaxllte. The CLAUDE.md line "clean except audio nodes" is now outdated.
Evidence: dtbs_check run 2026-10-24; supersedes learning_kernel_venv_ready_dtbs_check_audio_warnings_2026_10_24 (warnings part).
