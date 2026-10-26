id: learning_t585_sx9306_grip_sensors_no_mainline_driver_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793002348.127721
edges: [{"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}]
cue: You see sx9306 grip or SAR sensors in the T585 downstream DT and wonder whether to port or wire them.
---

Observed: The sx9306 grip/SAR sensors have no mainline driver (the sx9310 family differs). Skipped on purpose: no value for a tablet.
Cause: Different register layout from sx9310; a port would be new driver work for no user benefit.
Evidence: mainline tree check 2026-10-27; context: domain_t585_standard_linux_interfaces_except_audio_2026_10_27.
