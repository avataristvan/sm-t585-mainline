id: domain_t585_audio_modules_load_at_boot_from_initramfs_2026_10_24
type: domain
area: mainline
perspective: the-coder
created: 1792829664.876272
edges: [{"target_id": "pattern_t585_reload_audio_modules_from_host_2026_10_24", "edge_type": "related"}, {"target_id": "domain_stage1_enable_modules_for_stmfts_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_jack_switch_module_param_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_dapm_delay_event_on_both_widgets_skip_if_done_2026_10_24", "edge_type": "related"}]
cue: You wonder why the SM-T585 sound card is up after boot, or want to change which audio modules or machine options load at boot.
---

Decision: Audio loads at boot. kernel/build-stage1.sh puts the 13 sound modules (+ modules.order) into the initramfs /lib/modules and tinymix/pcmplay/pcmrec into /bin (from kernel/out/alsa if present). initramfs/init insmods them in the background after the USB debug shells are up. Machine module options are set via SND_MACHINE_OPTS in init.
Why: A hanging driver must not cost the debug shell (hence background, after the shells). S-Boot drops the kernel cmdline, so module options cannot come from there. Modules instead of built-in keep runtime reload (reload.sh) and module params (jack_switch, adc_power_delay) usable.
Scope: kernel/build-stage1.sh, kernel/initramfs/init. Card is up ~2.4 s after boot. Boot image sha1 70d2b4ab8a98bf07e15a39a0d296debbed56a286 (pending flash when written); the previous a0b677a5... had the broken single-widget ADC delay.
