id: pattern_t585_runtime_switch_hypothesis_tests_one_diagnostic_kernel_2026_10_29
type: pattern
area: workflow
perspective: agent
created: 1793306202.247288
edges: [{"target_id": "pattern_t585_debug_delays_as_runtime_module_params_bisect_2026_10_26", "edge_type": "related"}]
cue: You must decide between several competing hypotheses on the SM-T585 and each would need its own kernel build and flash.
---

Rule: Build one diagnostic kernel with one module_param per hypothesis variant on the built-in driver (samsung_dsim), take register snapshots at fixed checkpoints, and run the variants with a host runner script that stops when boot_id changes (a crash/reboot).
When: Competing hypotheses for a hang or timing bug on this device.
Why: It decided H1 (keep runtime PM on) versus H2 (display mode + stand-by at init end) for the DSI re-enable bug in one session without rebuilds: base 386 FIFO timeouts, H1 434, H2 zero. Extends pattern_t585_debug_delays_as_runtime_module_params_bisect_2026_10_26 from delays to whole hypotheses.
