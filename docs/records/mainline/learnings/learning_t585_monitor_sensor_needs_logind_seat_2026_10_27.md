id: learning_t585_monitor_sensor_needs_logind_seat_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793045345.65587
edges: [{"target_id": "learning_t585_sensors_accel_light_mainline_drivers_i2c7_2026_10_27", "edge_type": "related"}]
cue: Testing T585 screen orientation with monitor-sensor over ssh and getting "Sensor claim not allowed".
---

Observed: monitor-sensor (iio-sensor-proxy client) run from an ssh session fails with "Sensor claim not allowed".
Cause: polkit denies the sensor claim to a session without a logind seat; the ssh session has none.
Evidence: HW session 2026-10-27. Instead: test orientation from inside the GNOME session on the tablet.
