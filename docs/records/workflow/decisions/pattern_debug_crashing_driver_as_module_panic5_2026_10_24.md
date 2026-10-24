id: pattern_debug_crashing_driver_as_module_panic5_2026_10_24
type: pattern
area: workflow
perspective: the-coder
created: 1792848642.998854
edges: [{"target_id": "learning_t585_tmu_clocked_by_cpucl0_gates_2026_10_24", "edge_type": "related"}]
cue: A built-in driver crashes the boot and each try costs a TWRP round-trip to reflash.
---

Rule: To debug a driver that crashes the boot, build it =m temporarily. The kernel boots; run `echo 5 > /proc/sys/kernel/panic` first, then insmod it by hand, so a crash just reboots into the same kernel.
When: Bring-up debugging of a driver whose crash would otherwise need a reflash via TWRP. Note: the exynos-tmu module cannot be re-insmodded after rmmod (irq type mismatch, mapping not disposed), so reboot between tries.
Why: Avoids the TWRP round-trip per try (found during TMU chunk 1, see learning_t585_tmu_clocked_by_cpucl0_gates_2026_10_24).
