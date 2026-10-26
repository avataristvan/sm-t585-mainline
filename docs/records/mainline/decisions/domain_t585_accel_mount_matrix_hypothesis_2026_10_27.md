id: domain_t585_accel_mount_matrix_hypothesis_2026_10_27
type: domain
area: mainline
perspective: agent
created: 1793002347.886455
edges: [{"target_id": "learning_t585_sensors_accel_light_mainline_drivers_i2c7_2026_10_27", "edge_type": "derived_from"}, {"target_id": "learning_t585_sensors_lis2hh12_cm3323_probe_on_hw_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_accel_mount_matrix_confirmed_on_hw_2026_10_27", "edge_type": "related"}]
cue: The T585 screen rotation or accelerometer axes come out wrong or mirrored under iio-sensor-proxy.
---

Decision (hypothesis): The accel mount-matrix is diag(1,1,-1), derived from downstream axis_map identity plus negate_z. Raw IIO values stay in the chip frame; only consumers apply the matrix. To be fixed on HW with the pose table in docs/sensors-test-plan-2026-10-27.md, using an hwdb ACCEL_MOUNT_MATRIX override (no rebuild needed).
Why: det(diag(1,1,-1)) = -1 is a mirror, which no physical mounting gives, so a hidden second transform likely existed in Samsung's HAL; the matrix is therefore unconfirmed.
Scope: SM-T585 accelerometer (LIS2HH12 on i2c7), board DTS and hwdb.
