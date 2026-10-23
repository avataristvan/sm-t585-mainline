id: learning_t585_i2cx_rt5659_register_access_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792788230.844604
edges: [{"target_id": "learning_t585_audio_roughness_volume_independent_open_2026_10_23", "edge_type": "related"}, {"target_id": "learning_i2cx_and_evdecode_tools_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_i2cx_full_four_digit_rt5659_address_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_speaker_silent_clicks_only_mainline_2026_10_23", "edge_type": "related"}]
cue: You want to poke or read a single RT5659 register on the running SM-T585 without rebuilding a module.
---

Observed: kernel/tools/i2cx writes RT5659 registers directly (16-bit register, 16-bit value, big-endian): write `i2cx 2 0x1b 0x00 0x8a 0x01 0x20` (ASRC_8 = 0x0120); read `i2cx 2 0x1b 0x00 0x8a r2`. It bypasses the driver's regcache, so values are for tests only and the driver's cache does not know them; fold working settings into the drivers afterwards. After a reboot, kernel/out/alsa/setup.sh restores the mixer/tinymix state in one command.
Cause: stage 1 has no regmap write access from userland for this codec except debugfs read.
Evidence: kernel/tools/i2cx/, kernel/out/alsa/setup.sh; see learning_i2cx_and_evdecode_tools_2026_10_23.
