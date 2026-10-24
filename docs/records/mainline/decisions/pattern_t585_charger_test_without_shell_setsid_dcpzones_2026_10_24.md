id: pattern_t585_charger_test_without_shell_setsid_dcpzones_2026_10_24
type: pattern
area: mainline
perspective: agent
created: 1792867169.706784
edges: [{"target_id": "learning_t585_sm5703_charger_zones_verified_temp_offset_2026_10_24", "edge_type": "related"}]
cue: You need a test that runs only with the wall charger plugged in or without a USB host, and the shell dies on unplug.
---

Rule: For a test that needs the wall charger or no USB host, run a script that waits for usb_type [DCP], logs to /tmp/dcp.log and tty0, and start it with setsid (kernel/tools/batt/dcpzones.sh).
When: Charger zone tests (COOL/WARM/HOT) or anything that outlives the USB unplug.
Why: A plain `&` background job is risky because the hangup on unplug ends it; setsid survives it.
