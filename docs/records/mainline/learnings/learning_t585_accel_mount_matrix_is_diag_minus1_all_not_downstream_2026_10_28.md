id: learning_t585_accel_mount_matrix_is_diag_minus1_all_not_downstream_2026_10_28
type: learning
area: mainline
perspective: agent
created: 1793226617.821823
edges: [{"target_id": "learning_t585_accel_mount_matrix_confirmed_on_hw_2026_10_27", "edge_type": "supersedes"}, {"target_id": "domain_t585_accel_mount_matrix_hypothesis_2026_10_27", "edge_type": "supersedes"}]
cue: You doubt or change the T585 accelerometer mount-matrix, or reason from determinant +1 / downstream negate_z to pick axis signs.
---

Observed: The correct LIS2HH12 mount-matrix is diag(-1,-1,-1), not the downstream-derived diag(1,1,-1). Verified with iio-sensor-proxy in three poses with the user: upright -> normal, Home-right landscape -> right-up, flat -> face-up. A diag(1,-1,-1) attempt gave left-up and was wrong. (src/mainline commit 66eb17759.)
Cause: The earlier "verified in 3 poses" learning only checked the sign of single axes in the chip frame, not the orientation iio-sensor-proxy derives. The "proper rotation, determinant +1" argument does not decide it here: the sign convention of the consumer (iio-sensor-proxy) governs, so only the consumer's output on real poses counts.
Evidence: HW session 2026-10-28 with the user; commit 66eb17759. Replaces learning_t585_accel_mount_matrix_confirmed_on_hw_2026_10_27 and domain_t585_accel_mount_matrix_hypothesis_2026_10_27.
