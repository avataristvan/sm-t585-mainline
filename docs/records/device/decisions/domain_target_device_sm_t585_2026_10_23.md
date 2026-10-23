id: domain_target_device_sm_t585_2026_10_23
type: domain
area: device
perspective: user
created: 1792769191.953488
edges: [{"target_id": "decision-p613-android-over-pmos", "edge_type": "related"}]
cue: You are about to build, flash or look up hardware facts for this repo and assume the device is the SM-T580 gtaxlwifi.
---

Decision: The physical test device is a Samsung SM-T585 (gtaxllte, LTE, board "Galaxy Tab A LTE 05", hw_rev 5/6), not the SM-T580 (gtaxlwifi). Port work targets gtaxllte. The device data dump lives in device-dump/sm-t585/ (live DT, dmesg, config.gz, boot/recovery images, firmware, sysfs inventory; EFS and modem intentionally not dumped).
Why: adb model check on 2026-10-23.
Scope: galaxy-tab-a-10. CLAUDE.md project text still describes the T580 and is stale on this point.
