id: learning_i2cx_and_evdecode_tools_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792772532.827232
edges: [{"target_id": "learning_t585_touch_works_stmfts_fts1a096_2026_10_23", "edge_type": "related"}, {"target_id": "todo_sm5703_charger_fuel_gauge_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_i2cx_rt5659_register_access_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_raw_read_addresses_por_charger_undercharges_2026_10_24", "edge_type": "related"}]
cue: You need to poke an i2c chip or capture and decode raw evdev input on the stage-1 SM-T585 without extra userland.
---

Observed: kernel/tools/i2cx/ is a 7.6 KB static aarch64 i2c write/read tool (I2C_RDWR) built with the kernel tree's nolibc: tools/i2cx/build.sh <kernel-build-dir> <out>; needs "make headers" first; -fno-builtin is needed so clang does not emit puts. It works while a driver owns the address. Usage on device: i2cx <bus> <addr> <wbytes...> [rN]. To read a chip's FIFO without the driver's IRQ handler interfering, disable the chip's INT output first.
kernel/tools/evdecode.py decodes raw evdev captures. On stage 1 capture with "cat /dev/input/eventN > file" (busybox hexdump fails with EINVAL because evdev needs reads >= 24 bytes) and pull the file via base64 over the ACM shell.
Cause: stage 1 has only busybox; no i2c-tools, and evdev reads must be at least one struct input_event.
Evidence: kernel/tools/i2cx/, kernel/tools/evdecode.py; used in learning_t585_touch_works_stmfts_fts1a096_2026_10_23.
