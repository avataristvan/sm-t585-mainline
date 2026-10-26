id: learning_t585_accel_mount_matrix_confirmed_on_hw_2026_10_27
type: learning
area: mainline
perspective: user
created: 1793045345.411883
edges: [{"target_id": "domain_t585_accel_mount_matrix_hypothesis_2026_10_27", "edge_type": "confirms"}]
cue: Checking or changing the T585 accelerometer mount-matrix, or doubting diag(1,1,-1) because its determinant is -1.
---

Observed: The LIS2HH12 mount-matrix diag(1,1,-1) ("1, 0, 0; 0, 1, 0; 0, 0, -1") is correct on HW, checked with the user posing the tablet (scale 0.000598 m/s2/LSB, raw values in the chip frame):
- portrait upright, home button down, screen to user, leaning back: (-1366, 14095, -8478) -> +y up, z positive after the matrix
- landscape, home button right: (15551, -103, -387) -> +x up
- flat, screen up: (-792, 93, -16073) -> z after the matrix +9.6 m/s2
Cause: The determinant of -1 (a mirror) is not a problem: the raw chip frame is left-handed relative to the screen frame, so the matrix only flips z to match the standard frame. The hypothesis is confirmed; no hwdb ACCEL_MOUNT_MATRIX override is needed.
Evidence: HW session 2026-10-27 with the user; pose table in docs/sensors-test-plan-2026-10-27.md; record domain_t585_accel_mount_matrix_hypothesis_2026_10_27.
