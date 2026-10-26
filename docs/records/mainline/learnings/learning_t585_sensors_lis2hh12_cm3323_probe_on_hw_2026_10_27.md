id: learning_t585_sensors_lis2hh12_cm3323_probe_on_hw_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793043524.835449
edges: [{"target_id": "learning_t585_sensors_accel_light_mainline_drivers_i2c7_2026_10_27", "edge_type": "confirms"}, {"target_id": "domain_t585_accel_mount_matrix_hypothesis_2026_10_27", "edge_type": "related"}]
cue: You check whether the T585 accelerometer or light sensor really work and how to read them (iio devices, scale, mount matrix).
---

Observed: HW-verified 2026-10-27: sensors probe. lis2hh12 (iio:device3) reads about (4871, 713, -15220) raw x 0.000598, so |g| is about 9.5 m/s2. cm3323 (iio:device2) gives RGB/clear counts. The mount-matrix orientation is still to be verified with the pose table.
Cause: n/a (drivers work with the DTS as built).
Evidence: HW test 2026-10-27; docs/sensors-test-plan-2026-10-27.md.
