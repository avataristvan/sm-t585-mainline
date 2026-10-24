id: pattern_debug_stage1_hangs_memtool_udplog_2026_10_23
type: pattern
area: workflow
perspective: agent
created: 1792778219.857117
edges: [{"target_id": "learning_usb_cable_fake_reboots_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_memtool_bus_error_on_mixer_use_regmap_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_pstore_needs_printk8_in_init_2026_10_24", "edge_type": "related"}]
cue: The SM-T585 stage-1 kernel hangs hard and pstore is empty, or you need to poke MMIO registers without devmem.
---

Rule: For stage-1 hangs use kernel/tools/memtool (no-libc mmap /dev/mem tool) for MMIO, and stream the kernel log to the host: on the device `syslogd -R 172.16.42.2:5514; klogd`, on the host kernel/tools/udplog.py writing kernel/out/logs/dev.log.
When: debugging freezes, bus errors or register state on the device in stage 1.
Why: busybox lacks devmem and read() on /dev/mem MMIO gives EFAULT; hard bus hangs leave pstore empty, so the remote log is the only trace.
