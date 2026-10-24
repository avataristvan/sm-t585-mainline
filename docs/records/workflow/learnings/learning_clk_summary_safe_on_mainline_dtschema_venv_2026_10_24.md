id: learning_clk_summary_safe_on_mainline_dtschema_venv_2026_10_24
type: learning
area: workflow
perspective: the-coder
created: 1792850693.289581
edges: [{"target_id": "learning_t585_clk_summary_reboots_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_sboot_leaves_cpu_clusters_902mhz_clk_summary_2026_10_24", "edge_type": "related"}, {"target_id": "learning_kernel_venv_ready_dtbs_check_audio_warnings_2026_10_24", "edge_type": "related"}]
cue: About to read clk_summary on the mainline stage-1 kernel, or dtbs_check/dt_binding_check fails because dtschema is missing.
---

Observed: /sys/kernel/debug/clk/clk_summary is safe on the MAINLINE stage-1 kernel (only the downstream one reboots); debugfs first needs `mount -t debugfs none /sys/kernel/debug`. dtschema is not installed globally; a throwaway venv with `pip install dtschema` works for dtbs_check and dt_binding_check.
Cause: the reboot is a downstream-kernel quirk; dtschema is simply not in the system Python.
Evidence: kernel #22 session 2026-10-24 (thermal chunk 3b); learning_t585_clk_summary_reboots_2026_10_23 (downstream).
