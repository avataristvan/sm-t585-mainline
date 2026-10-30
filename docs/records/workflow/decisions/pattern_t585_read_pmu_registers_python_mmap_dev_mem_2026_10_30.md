id: pattern_t585_read_pmu_registers_python_mmap_dev_mem_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793315637.143314
edges: [{"target_id": "learning_t585_psci_cpu_suspend_needs_pmu_cpu_local_pwr_cfg_clear_2026_10_30", "edge_type": "related"}, {"target_id": "pattern_debug_stage1_hangs_memtool_udplog_2026_10_23", "edge_type": "related"}]
cue: You need to read Exynos PMU or other SoC registers on the running pmOS and there is no devmem tool.
---

Rule: Read Exynos PMU registers on the running pmOS with python3 mmap of /dev/mem: open O_RDONLY|O_SYNC, page-aligned offset, then read the word.
When: Inspecting PMU/SoC registers on the running system (e.g. CPUx_CONFIGURATION/STATUS during cpuidle tests); busybox there has no devmem applet.
Why: CONFIG_DEVMEM=y with STRICT_DEVMEM but without IO_STRICT_DEVMEM allows it for register space. Stage-1 uses kernel/tools/memtool instead.
