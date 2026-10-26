id: pattern_t585_debug_delays_as_runtime_module_params_bisect_2026_10_26
type: pattern
area: workflow
perspective: agent
created: 1793048762.738477
edges: [{"target_id": "learning_t585_dsi_hang_decon_envid_before_dsim_init_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_dsi_porch_pixels_not_byteclock_edge_strip_2026_10_26", "edge_type": "related"}, {"target_id": "learning_memtool_syntax_no_subcommands_hang_2026_10_23", "edge_type": "related"}]
cue: You bisect a hang or timing bug on the SM-T585 and every experiment would mean a kernel rebuild and flash.
---

Rule: Make debug delays and overrides runtime-switchable via module_param, also in built-in drivers (/sys/module/samsung_dsim/parameters, /sys/module/exynosdrm/parameters), so a bisect needs only reboots, not rebuilds. Dump the DSIM/DECON SFRs before modprobe (panel module blacklisted) to get the bootloader's working register values for a diff.
When: Hangs and timing bugs on this device (it worked for the DSI hang and the edge strip).
Why: Rebuild plus flash per experiment is slow; the register diff against the bootloader shows candidates fast. Pitfalls: memtool takes hex addresses only (decimal -> SIGBUS); after every kernel rebuild copy the panel .ko too, else module BTF validation fails (-22); do not `pkill -f` a pattern that appears in your own shell command line (it kills your shell). Root on the tablet: see CLAUDE.local.md.
