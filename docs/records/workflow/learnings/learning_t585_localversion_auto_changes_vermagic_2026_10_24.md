id: learning_t585_localversion_auto_changes_vermagic_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792822788.469499
edges: [{"target_id": "learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24", "edge_type": "related"}, {"target_id": "learning_module_new_device_test_before_flash_2026_10_24", "edge_type": "related"}]
cue: Kernel modules built after a commit in src/mainline are refused with "invalid module format" by the booted kernel.
---

Observed: Committing in the src/mainline submodule changed the setlocalversion git hash, so modules built afterwards had a different vermagic and kernel #9 refused them ("invalid module format").
Cause: CONFIG_LOCALVERSION_AUTO appends the git hash to the kernel release.
Fix: CONFIG_LOCALVERSION_AUTO disabled in kernel/gtaxllte-stage1.config -> stable release "7.3.0-gtaxllte+" from kernel #11 on (boot sha1 e13008b307fce06ca5a2b405998e10f60e259d86). Previous boot images kept as kernel/out/boot-stage1-k9.img and -k10.img; k10 modules in kernel/out/snd-k10.
Evidence: kernel/gtaxllte-stage1.config, kernel/out/.
