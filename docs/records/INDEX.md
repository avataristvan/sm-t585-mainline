# Decision Records Index

| id | area | type | title | status |
|---|---|---|---|---|
| anti-pattern_make_m_dir_pollutes_source_tree_2026_10_23 | workflow | anti-pattern | Tried: Building modules with `make M=<dir>` (e.g. `make M=sound/soc/samsung`) wi | active |
| decision-p613-android-over-pmos | general | domain | Decision: Guiding decision (2026-09-19): the newer tablet SM-P613 (Galaxy Tab S6 | active |
| domain_archivist_candidates_sent_immediately_2026_10_23 | workflow | domain | Decision: Record candidates are sent to the archivist immediately when they aris | active |
| domain_bringup_interactive_devteam_for_drivers_2026_10_23 | workflow | domain | Decision: Device bring-up steps (DTS, boot-image packaging, flash tests) stay in | active |
| domain_delegate_side_todos_to_smaller_models_2026_10_23 | workflow | domain | Decision: Suitable side todos may be delegated to smaller (cheaper) models. Devi | active |
| domain_flash_boot_no_confirmation_2026_10_23 | workflow | domain | Decision: Flashing BOOT needs no confirmation in this bring-up (user, 2026-10-23 | active |
| domain_kernel_config_trim_policy_2026_10_23 | mainline | domain | Decision: Kernel config trim policy for the SM-T585. Build in (=y) what the devi | superseded_by: domain_kernel_config_trim_policy_bt_2026_10_23 |
| domain_kernel_config_trim_policy_bt_2026_10_23 | mainline | domain | Decision: Kernel config trim policy for the SM-T585. Build in (=y) what the devi | superseded_by: domain_kernel_config_trim_policy_periph_net_2026_10_23 |
| domain_kernel_config_trim_policy_periph_net_2026_10_23 | mainline | domain | Decision: Kernel config trim policy for the SM-T585. Build in (=y) what the devi | active |
| domain_priority_audio_bt_dsi_2026_10_23 | goal | domain | Decision: Priority order after touch: internal audio (LPASS + I2S + RT5659) firs | active |
| domain_public_repo_gitignore_and_privacy_2026_10_24 | workflow | domain | Decision: The whole project is a git repo, public on github.com/avataristvan/sm- | active |
| domain_stage1_enable_modules_for_stmfts_2026_10_23 | mainline | domain | Decision: Enable CONFIG_MODULES in the stage-1 kernel and build stmfts as a modu | active |
| domain_stmfts_fts1a096_variant_2026_10_23 | mainline | domain | Decision: Support the FTS1A096 by adding a chip variant to mainline stmfts (new  | active |
| domain_stmfts_patches_not_upstreamed_2026_10_23 | mainline | domain | Decision: The stmfts (FTS1A096 variant), board DTS and binding patches are not s | active |
| domain_t585_default_audio_routing_in_machine_driver_2026_10_24 | mainline | domain | Decision: Default audio routing lives in the machine driver: DAC1 -> Stereo DAC  | active |
| domain_t585_lean_linux_music_device_2026_10_23 | goal | domain | Decision: Revive the SM-T585 as a lean-Linux music device (reopened explicitly b | active |
| domain_t585_own_machine_driver_for_audio_2026_10_23 | mainline | domain | Decision: A small own machine driver for gtaxllte (src/mainline/sound/soc/samsun | active |
| domain_t585_touch_keys_menu_left_back_right_2026_10_23 | mainline | domain | Decision: On the SM-T585 the left capacitive key (left of Home) is KEY_MENU and  | active |
| domain_target_device_sm_t585_2026_10_23 | device | domain | Decision: The physical test device is a Samsung SM-T585 (gtaxllte, LTE, board "G | active |
| learning_build_artifacts_not_in_tmp_2026_10_23 | workflow | learning | Observed: Build artifacts must live in the project (kernel/build, kernel/out, ke | active |
| learning_claude_auto_mode_denies_boot_flash_2026_10_23 | workflow | learning | Observed: In Claude Code auto mode the classifier denied the BOOT flash (dd to / | active |
| learning_defconfig_modules_pinned_builtin_2026_10_23 | mainline | learning | Observed: While CONFIG_MODULES was off, merge_config + olddefconfig promoted all | active |
| learning_devsh_first_ttyacm_and_stale_query_2026_10_23 | workflow | learning | Observed: After a device reboot the host CDC-ACM node may come back as /dev/ttyA | active |
| learning_fts1a096_rejected_commands_and_chip_info_2026_10_23 | mainline | learning | Observed: FTS1A096 error event "0f ba d0 00 c0 de 00 00" ("BAD0 C0DE") means com | active |
| learning_gap_survey_compatible_is_hypothesis_2026_10_23 | mainline | learning | Observed: learning_mainline_73_exynos7870_gap_2026_10_23 said for the touch "FTS | active |
| learning_host_arch_update_missing_cdc_modules_2026_10_23 | workflow | learning | Observed: After an Arch kernel update without reboot, the cdc_ncm/cdc_acm module | active |
| learning_host_ncm_iface_name_changes_2026_10_23 | workflow | learning | Observed: The host USB NCM interface name changes per port and replug (enp0s20f0 | active |
| learning_host_ncm_iface_name_confirmed_again_2026_10_23 | workflow | learning | Observed: After a reboot the host NCM interface was enp0s20f0u6 again, and the n | active |
| learning_host_nm_profile_t585_usb_bound_to_iface_name_2026_10_23 | workflow | learning | Observed: After a device reboot the host USB-NCM NIC can re-enumerate under anot | superseded_by: learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23 |
| learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23 | workflow | learning | Observed: The host NM profile t585-usb is now matched by driver instead of inter | active |
| learning_http_server_poll_before_device_wget_2026_10_23 | workflow | learning | Observed: A backgrounded `python3 -m http.server` is not ready immediately. Once | active |
| learning_i2cx_and_evdecode_tools_2026_10_23 | workflow | learning | Observed: kernel/tools/i2cx/ is a 7.6 KB static aarch64 i2c write/read tool (I2C | active |
| learning_mainline_73_exynos7870_gap_2026_10_23 | mainline | learning | Observed: Mainline Linux 7.3 contains Exynos7870 support (exynos7870.dtsi; board | active |
| learning_mainline_stage1_boot_t585_2026_10_23 | mainline | learning | Observed: Mainline 7.3 stage-1 boot on SM-T585 works (2026-10-23) with the new b | active |
| learning_memtool_syntax_no_subcommands_hang_2026_10_23 | workflow | learning | Observed: kernel/tools/memtool syntax is `memtool <hex-addr> [hex-value]` (read, | active |
| learning_name_physical_controls_in_hw_tests_2026_10_23 | workflow | learning | Observed: When asking the user to press "the keys" during a hardware test, name  | active |
| learning_rt5659_driver_gpio_names_unprefixed_2026_10_23 | mainline | learning | Observed: sound/soc/codecs/rt5659.c requests the GPIOs "ldo1-en" and "reset" (pr | active |
| learning_speech_tests_user_starts_late_record_12s_2026_10_24 | workflow | learning | Observed: In speech tests the user only starts speaking once they read the chat  | active |
| learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23 | workflow | learning | Observed: The static Alpine busybox in the stage-1 initramfs (kernel/prebuilt/bu | superseded_by: learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23 |
| learning_stage1_flash_via_ncm_wget_unverified_2026_10_23 | workflow | learning | Observed: UNVERIFIED, not yet exercised. While the device runs stage 1 (no adb), | superseded_by: learning_stage1_flash_via_ncm_wget_verified_2026_10_23 |
| learning_stage1_flash_via_ncm_wget_verified_2026_10_23 | workflow | learning | Observed: Flashing a new boot image over NCM works (exercised 2026-10-23 with th | active |
| learning_stage1_setup_sh_lacks_i2cx_fetch_2026_10_24 | workflow | learning | Observed: setup.sh does not fetch i2cx; after a reboot /tmp/i2cx is missing (wge | active |
| learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23 | workflow | learning | Observed: telnetd and udhcpd now run from boot in stage 1. Solution: Alpine v3.2 | active |
| learning_stage1_tinymix_needs_musl_loader_2026_10_23 | workflow | learning | Observed: Alpine tinymix on stage 1 needs /lib/ld-musl-aarch64.so.1 plus a symli | active |
| learning_stage1_tinymix_needs_subcommand_2026_10_24 | workflow | learning | Observed: tinymix (this build) needs the subcommand: `tinymix -D 0 contents` lis | active |
| learning_stage1_tmp_is_tmpfs_refetch_modules_2026_10_23 | workflow | learning | Observed: Files downloaded to /tmp on the stage-1 device (for example the sound  | active |
| learning_stmfts_fts1a096_not_command_compatible_2026_10_23 | mainline | learning | Observed: The SM-T585 touch controller STM FTS1A096 (downstream fts7 driver, stm | active |
| learning_stmfts_kbd_attach_error_only_on_runtime_insmod_2026_10_23 | mainline | learning | Observed: With stmfts built in (=y) the "failed to attach handler kbd ... -13" m | active |
| learning_t585_adc_loopback_zeros_dac_mix_mute_nopm_rt5659_2026_10_24 | mainline | learning | Observed: RT5659 ADC loopback (Stereo1 ADC1/ADC2 Source = "DAC MIX") returned ex | active |
| learning_t585_adma_bus_clock_apb_aud_2026_10_23 | mainline | learning | Observed: The Exynos7870 ADMA (PL330 @14890000) bus clock is APB_AUD, not APB_AU | active |
| learning_t585_aud_pll_97_5mhz_not_98_304_2026_10_23 | mainline | learning | Observed: AUD_PLL runs at 97.5 MHz under mainline, not 98.304 MHz, so 48 kHz aud | superseded_by: learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23 |
| learning_t585_aud_pll_is_fractional_pll36xx_98_304_2026_10_23 | mainline | learning | Observed: The 7870 DISPAUD AUD_PLL is a fractional PLL1431x (downstream pwrcal:  | active |
| learning_t585_aud_pll_request_target_plus_100hz_2026_10_23 | mainline | learning | Observed: Mainline AUD_PLL (pll_36xx) runs at 98 304 019 Hz, a few Hz above 98.3 | active |
| learning_t585_audio_defaults_in_machine_driver_work_on_hw_2026_10_24 | mainline | learning | Observed: On kernel #11 (boot sha1 e13008b307fce06ca5a2b405998e10f60e259d86, rel | active |
| learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23 | mainline | learning | Observed: Downstream topology is NOT I2S0 -> mixer -> codec as a codec2codec cha | active |
| learning_t585_audio_path_rt5659_s1402x_gap_2026_10_23 | mainline | learning | Observed: SM-T585 audio path: PL330 adma@14890000 -> I2S0@148A0000 -> s1402x int | active |
| learning_t585_audio_roughness_not_player_or_dma_period_2026_10_23 | mainline | learning | Observed: The SM-T585 audio roughness ("ring-modulator") is not caused by the pl | active |
| learning_t585_audio_roughness_volume_independent_open_2026_10_23 | mainline | learning | Observed: After the click fix the 440 Hz tone is rough ("ring modulator", "Amiga | superseded_by: learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23 |
| learning_t585_bootloader_fb_a8r8g8b8_2026_10_23 | mainline | learning | Observed: On mainline, the SM-T585 bootloader framebuffer at 0x67000000 is a8r8g | active |
| learning_t585_capture_not_running_i2s0_rx_needed_2026_10_23 | mainline | learning | Observed: Capture on the mainline SM-T585 card does not run yet. tinycap -t 5 re | superseded_by: learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23 |
| learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23 | mainline | learning | Observed: Capture DOES run in real time on the mainline SM-T585 card; the instan | active |
| learning_t585_capture_zeros_fixed_by_adc_sto1_asrc_2026_10_24 | mainline | learning | Observed: Codec-side capture zeros on mainline SM-T585 were caused by the ADC ST | active |
| learning_t585_clk_summary_reboots_2026_10_23 | device | learning | Observed: On the SM-T585 downstream 3.18 kernel, reading /sys/kernel/debug/clk/c | active |
| learning_t585_dispaud_reset_pulse_needed_2026_10_23 | mainline | learning | Observed: DISPAUD_CFG (0x148F1000) audio soft resets (bit0 mixer, 1 MI2S, 2 AMP, | active |
| learning_t585_downstream_kernel_source_and_roms_2026_10_23 | device | learning | Observed: Working downstream kernel for gtaxllte/gtaxlwifi: github.com/Exynos787 | active |
| learning_t585_headset_mic_in1_needs_ejd_ctrl_1_0x70c0_2026_10_24 | mainline | learning | Observed: Headset mic on SM-T585 = IN1 (single-ended) + MICBIAS1 (downstream DT  | active |
| learning_t585_i2cx_rt5659_register_access_2026_10_23 | workflow | learning | Observed: kernel/tools/i2cx writes RT5659 registers directly (16-bit register, 1 | active |
| learning_t585_i2s0_is_exynos7_i2s1_three_clocks_2026_10_23 | mainline | learning | Observed: SM-T585 I2S0 matches the mainline `samsung,exynos7-i2s1` register layo | active |
| learning_t585_i2s0_rclksrc_dtsi_fix_verified_2026_10_23 | mainline | learning | Observed: The permanent fix for the I2S0 RCLKSRC roughness is in the DTS, not at | active |
| learning_t585_i2s0_rclksrc_pclk_causes_roughness_2026_10_23 | mainline | learning | Observed: Root cause of the "ring-modulator" roughness: Exynos7870 I2S0 MOD[10]  | active |
| learning_t585_i2s_mainline_sysclk_calls_opclk_rclksrc_2026_10_23 | mainline | learning | Observed: In the mainline machine driver gtaxllte_rt5659.c: (1) snd_soc_dai_set_ | active |
| learning_t585_lineage_capture_dump_procedure_2026_10_24 | workflow | learning | Observed: Lineage capture-dump procedure: script kernel/out/alsa/lineage-capdump | active |
| learning_t585_localversion_auto_changes_vermagic_2026_10_24 | workflow | learning | Observed: Committing in the src/mainline submodule changed the setlocalversion g | active |
| learning_t585_lpass_is_not_exynos5433_lpass_2026_10_23 | mainline | learning | Observed: The Exynos 7870 "LPASS" (downstream sound/soc/samsung/lpass-exynos7870 | active |
| learning_t585_machine_module_reload_leaves_playback_silent_2026_10_23 | mainline | learning | Observed: After rmmod/insmod of the machine module (snd-soc-gtaxllte-rt5659) pla | superseded_by: learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24 |
| learning_t585_main_mic_in3_micbias2_lineage_ref_2026_10_24 | mainline | learning | Observed: Main mic on SM-T585 = IN3 with MICBIAS2. Lineage capture dump (recorde | active |
| learning_t585_memtool_bus_error_on_mixer_use_regmap_2026_10_23 | mainline | learning | Observed: kernel/tools/memtool (/dev/mem) gave "Bus error" on the mixer register | active |
| learning_t585_memtool_works_on_mixer_and_i2s0_during_audio_2026_10_23 | mainline | learning | Observed: memtool works on the s1402x mixer (e.g. 0x14880058) and on I2S0 (0x148 | active |
| learning_t585_pmu_aud_sys_pwr_alone_gives_no_sound_2026_10_23 | mainline | learning | Observed: PMU 0x10481340 (GPIO_MODE_AUD_SYS_PWR) reads 0 on mainline; setting bi | active |
| learning_t585_pmu_clkout_7870_mainline_wiring_2026_10_23 | mainline | learning | Observed: PMU CLKOUT on 7870 works via mainline drivers/clk/samsung/clk-exynos-c | active |
| learning_t585_pmu_regmap_cat_hangs_device_2026_10_23 | device | learning | Observed: Under Lineage (downstream 3.18), `cat /d/regmap/10480000.system-contro | active |
| learning_t585_poweroff_f_works_stage1_2026_10_23 | mainline | learning | Observed: On stage 1 (mainline 7.3), `poweroff -f` from the shell switched the S | active |
| learning_t585_rt5659_clicks_fixed_by_dac_asrc_2026_10_23 | mainline | learning | Observed: Clicks on the headphone output were caused by the RT5659 running from  | active |
| learning_t585_rt5659_codec_probes_mainline_2026_10_23 | mainline | learning | Observed: The RT5659 codec probes on mainline 7.3 on the SM-T585 (verified on ha | active |
| learning_t585_rt5659_dapm_mixer_default_needs_kctl_put_after_register_2026_10_24 | mainline | learning | Observed: Setting RT5659 DAPM mixer controls (e.g. "Stereo DAC MIXL DAC L1 Switc | active |
| learning_t585_rt5659_pll1_from_bclk1_silent_mclk_asrc_works_2026_10_23 | mainline | learning | Observed: PLL1 sourced from BCLK1 (codec_bfs = 64 or 32 at 48 kHz) gave silence  | active |
| learning_t585_rt5659_pll1_from_mclk_26mhz_pmu_clkout_2026_10_23 | mainline | learning | Observed: On the SM-T585 the RT5659 PLL1 at 48 kHz is fed from a 26 MHz MCLK, NO | active |
| learning_t585_rt5659_remove_leaves_regcache_stale_fixed_2026_10_24 | mainline | learning | Observed: After rmmod/insmod of the machine module snd-soc-gtaxllte-rt5659 playb | active |
| learning_t585_s1402x_mixer_driver_works_2026_10_23 | mainline | learning | Observed: The local s1402x mixer driver works: src/mainline/sound/soc/samsung/s1 | active |
| learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23 | mainline | learning | Observed: Headphones stayed silent on mainline although the whole RT5659 DAPM pa | active |
| learning_t585_s1402x_mixer_same_for_capture_and_playback_2026_10_24 | mainline | learning | Observed: The s1402x mixer registers are identical under Lineage during capture  | active |
| learning_t585_speaker_dump_lineage_reference_and_roundtrip_2026_10_24 | workflow | learning | Observed: Lineage speaker reference dumps exist: device-dump/sm-t585-audio-ref/l | active |
| learning_t585_speaker_rt5659_diffs_not_sufficient_alone_2026_10_24 | mainline | learning | Observed: Other RT5659 differences Lineage vs mainline during speaker play were  | active |
| learning_t585_speaker_session_repeated_guessing_loop_2026_10_23 | workflow | learning | Observed: The speaker session repeated the listening-and-guessing loop for about | active |
| learning_t585_speaker_silent_clicks_only_mainline_2026_10_23 | mainline | learning | Observed: SM-T585 speakers on mainline: no tone yet, only class-D switch clicks  | superseded_by: learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24 |
| learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24 | mainline | learning | Observed: SM-T585 mainline speakers were silent (class-D hiss only) because RT56 | active |
| learning_t585_touch_keys_event_0e_swapped_2026_10_23 | mainline | learning | Observed: The capacitive touch keys left and right of the physical Home key repo | active |
| learning_t585_touch_works_stmfts_fts1a096_2026_10_23 | mainline | learning | Observed: Touch WORKS on the SM-T585 (verified on hardware, 2026-10-23) with mai | active |
| learning_t585_uart_via_usb_jig_2026_10_23 | device | learning | Observed: SM-T585 UART access should work without disassembly via a microUSB jig | active |
| learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23 | mainline | learning | Observed: The "tinyplay returns rc=0 instantly" symptom was a userland problem,  | active |
| learning_usb_cable_fake_reboots_2026_10_23 | workflow | learning | Observed: A crumbling USB cable produced fake "reboots" (ttyACM re-enumeration). | active |
| pattern_debug_stage1_hangs_memtool_udplog_2026_10_23 | workflow | pattern | Rule: For stage-1 hangs use kernel/tools/memtool (no-libc mmap /dev/mem tool) fo | active |
| pattern_debugfs_regmap_shows_cache_compare_hw_reads_2026_10_24 | workflow | pattern | Rule: debugfs /sys/kernel/debug/regmap/<dev>/registers shows the regcache for no | active |
| pattern_devsh_for_all_device_commands_2026_10_23 | workflow | pattern | Rule: Use `python3 -I kernel/tools/devsh.py <command>` for all device commands o | active |
| pattern_dump_downstream_regmap_when_port_silent_2026_10_23 | workflow | pattern | Rule: When a minimal port of a vendor driver stays silent, dump the register sta | active |
| pattern_i2cx_full_four_digit_rt5659_address_2026_10_23 | workflow | pattern | Rule: Always give the full 4-hex-digit RT5659 register address to i2cx. Read: `i | active |
| pattern_mixer_loopback_fft_and_wallclock_rate_check_2026_10_23 | mainline | pattern | Rule: Measure the AP-side digital path with the s1402x mixer-internal loopback ( | active |
| pattern_poll_shell_after_reboot_f_under_10s_2026_10_24 | workflow | pattern | Rule: After `reboot -f` on stage 1, poll the shell every ~2 s instead of using f | active |
| pattern_propose_measurement_when_listening_stops_converging_2026_10_23 | workflow | pattern | Rule: When by-ear (or by-eye) tests stop converging, stop guessing and propose a | active |
| pattern_user_runs_audio_test_with_timed_register_write_2026_10_24 | workflow | pattern | Rule: When the user tests audio, let them run the test commands themselves via " | active |
| todo_audio_analysis_lpass_i2s_2026_10_23 | mainline | todo | TODO: Audio analysis: compare downstream lpass-exynos7870.c + i2s.c with mainlin | active |
| todo_bluetooth_then_dsi_panel_2026_10_23 | mainline | todo | TODO: Bluetooth (hci_qca + "tf" firmware), then the real DSI panel (hx8279 varia | active |
| todo_emmc_hs200_vmmc_ldo26_2026_10_23 | mainline | todo | TODO: eMMC: enable HS200 in the board DTS and pin vmmc (LDO26) to 2.85 V like An | active |
| todo_kernel_venv_pyusb_dtschema_2026_10_23 | workflow | todo | TODO: Create a persistent kernel/.venv (pyusb, dtschema) for dtbs_check and tool | active |
| todo_sm5703_charger_fuel_gauge_2026_10_23 | mainline | todo | TODO: SM5703 charger and fuel gauge. The downstream sm5703-fuelgauge (@0x71 on i | active |
| todo_stmfts_pm_runtime_before_register_2026_10_23 | mainline | todo | TODO: Fix an upstream-style bug in mainline stmfts: input_register_device() runs | active |
| todo_t585_headset_mic_auto_switch_jack_detect_2026_10_24 | mainline | todo | TODO: Automatic switching main mic <-> headset mic needs jack detection, which i | active |
| todo_t585_speaker_lineage_reference_dump_2026_10_23 | mainline | todo | TODO: The Lineage reference dump is done and the speaker works at runtime (see l | active |
| todo_trim_kernel_config_2026_10_23 | mainline | todo | TODO: Trim the kernel config per domain_kernel_config_trim_policy_2026_10_23, af | active |
| user_skill_profile_hw_bringup | general | user | User (avataristvan) skill profile for the galaxy-rab-a-10 device bring-up projec | active |
