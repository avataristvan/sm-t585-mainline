id: learning_module_new_device_test_before_flash_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792857706.908746
edges: [{"target_id": "learning_t585_localversion_auto_changes_vermagic_2026_10_24", "edge_type": "related"}]
cue: You built a new driver module and want to test it on the tablet before flashing a kernel with its DT node.
---

Observed: With CONFIG_LOCALVERSION_AUTO off, a new driver built as a module after a Kconfig change (kernel version counter went to #27) still loads into the running older kernel #26. It can then be bound to hardware that has no DT node yet via `echo <i2c id name> <addr> > /sys/bus/i2c/devices/i2c-N/new_device` (needs an i2c_device_id table in the driver). This tests a driver on hardware before any flash.
Cause: The vermagic no longer contains the git hash, so the module matches the older kernel's release; i2c new_device instantiates the client without DT.
Evidence: SM5703 fuel gauge bring-up 2026-10-24 (kernel #27 / #26); learning_t585_localversion_auto_changes_vermagic_2026_10_24.
