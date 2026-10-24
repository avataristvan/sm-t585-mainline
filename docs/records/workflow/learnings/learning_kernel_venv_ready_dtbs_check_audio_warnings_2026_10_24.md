id: learning_kernel_venv_ready_dtbs_check_audio_warnings_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792857707.107686
edges: [{"target_id": "learning_clk_summary_safe_on_mainline_dtschema_venv_2026_10_24", "edge_type": "related"}]
cue: You run make dt_binding_check or CHECK_DTBS=y, or wonder whether the gtaxllte DTS still passes dtbs_check.
---

Observed: kernel/.venv (python venv with dtschema + pyusb) now exists persistently and is git-ignored. Use `export PATH=$PWD/kernel/.venv/bin:$PATH` before `make dt_binding_check` / `CHECK_DTBS=y`. dtbs_check on exynos7870-gtaxllte currently reports warnings, all from the audio work: rt5659 ldo1-en/reset gpios and in3/in4-differential not in the binding; no schema for samsung,exynos7870-s1402x, samsung,exynos7870-dispaud-reset, samsung,gtaxllte-audio; i2s 'resets'. The fuel gauge node is clean.
Cause: The audio DT properties and compatibles have no upstream binding yet.
Evidence: dtbs_check run 2026-10-24. The CLAUDE.md claim "passes dtbs_check" is outdated. Closes todo_kernel_venv_pyusb_dtschema_2026_10_23.
