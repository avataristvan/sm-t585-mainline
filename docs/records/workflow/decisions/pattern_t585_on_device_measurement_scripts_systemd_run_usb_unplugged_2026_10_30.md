id: pattern_t585_on_device_measurement_scripts_systemd_run_usb_unplugged_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793317613.703438
edges: [{"target_id": "learning_t585_background_logger_dies_with_ssh_use_systemd_run_2026_10_27", "edge_type": "related"}]
cue: You start a long measurement script on the SM-T585 over ssh (esp. WiFi) or read battery current to judge power use.
---

Rule: Start on-device measurement scripts over ssh as a transient unit (`systemd-run --unit=<name> sh script`, as root on the tablet), not `setsid nohup ... &`. Over WiFi, ssh with `-o HostKeyAlias=172.16.42.1` reuses the known host key of the USB address. Read battery current only with USB unplugged.
When: Power/idle measurements of several minutes, run while the ssh session ends or the tablet is unplugged.
Why: `setsid nohup` children die at ssh logout (logind session scope cleanup). charge_control_end_threshold stops charging, but VBUS still powers the system, so the current is meaningless while plugged in.
