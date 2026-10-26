id: learning_t585_sensors_accel_light_mainline_drivers_i2c7_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793002347.127525
edges: [{"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_unused_regulator_cleanup_vdd_fixed_lcd_always_on_2026_10_26", "edge_type": "related"}, {"target_id": "learning_t585_sensors_lis2hh12_cm3323_probe_on_hw_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_monitor_sensor_needs_logind_seat_2026_10_27", "edge_type": "related"}]
cue: You wire or debug the T585 accelerometer or ambient light sensor and wonder which mainline driver and supplies apply.
---

Observed: The K2HH accelerometer is an ST LIS2HH12 (compatible st,lis2hh12, driver st_accel) and the light sensor a CM3323 (capella,cm3323); both have mainline drivers (bindings and build OK) on &i2c7 (0x138d0000): accel @0x1d with INT1 on gpa0-7 rising, light @0x10. Hardware unverified. cm3323 has no supply handling and no illuminance channel or scale (iio-sensor-proxy would use raw clear counts), so its rail LDO33 was made regulator-always-on. Accel vddio = ldo3 (downstream), vdd = ldo33 (inferred, not confirmed). iio-sensor-proxy already comes via postmarketos-base-ui-gnome. Package state: linux-samsung-gtaxllte pkgrel 4.
Cause: Mainline lacks supply handling in cm3323, so the always-on rail replaces it; the cleanup would otherwise switch a consumer-less rail off.
Evidence: board DTS exynos7870-gtaxllte.dts (i2c7 nodes), docs/sensors-test-plan-2026-10-27.md; built 2026-10-27, not tested on HW.
