id: domain_kernel_trim_chunk1_foreign_sound_disabled_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792830834.204885
edges: [{"target_id": "domain_kernel_config_trim_policy_periph_net_2026_10_23", "edge_type": "derived_from"}, {"target_id": "learning_defconfig_modules_pinned_builtin_2026_10_23", "edge_type": "related"}, {"target_id": "domain_kernel_trim_chunk2_builtin_pins_by_reason_2026_10_24", "edge_type": "related"}]
cue: You trim the kernel config further or wonder why foreign sound drivers are not built, or what the trim block at the end of stage1.config is.
---

Decision: Trim chunk 1 (2026-10-24, verified on hardware): the foreign defconfig =m sound drivers are disabled via a commented block of 44 "# CONFIG_... is not set" lines at the end of kernel/gtaxllte-stage1.config. Removed: Qualcomm WCD/WSA/LPASS/MSM8916 codecs, FSL ASRC/MICFIL/EASRC, Xilinx I2S/formatter/SPDIF, SOF toplevel, SND_SOC_USB (QDSP6 USB offload), ~25 codecs of other boards (AK, DA7213, ES, GTM601, MAX98090, RK817, RT5640, TAS, TLV320, WM, NAU8822), SOUNDWIRE(_QCOM), CRYPTO_BENCHMARK (tcrypt). Kept on purpose (audio/USB peripherals protected by the periph_net policy): ALSA core, Samsung I2S/s1402x/RT5659/machine chain, SND_USB_AUDIO + SND_RAWMIDI (OTG peripherals, f_midi later), SND_ALOOP, generic simple-card/audio-graph-card(2)/dmic/spdif/simple-amp/mux/hdmi-codec (hdmi-codec is selected by DRM bridges).
Why: Dead modules for other boards only cost build time. Result: 85 -> 28 built modules; =y side effects only SND_COMPRESS_ACCEL, SND_SOC_SOF_TOPLEVEL, SND_SOC_SOF_MTK_TOPLEVEL gone. Image size unchanged (19657216 bytes), so the gain is build time, not BOOT space. Release string unchanged (LOCALVERSION_AUTO off). Kernel #12 flashed (BOOT sha1 c3f1cd0d61183067b86f5c6752ef3ffa848f4cff); on device card SMT585 up at boot, 13 audio modules loaded from initramfs, 1 s pcmrec capture has data, pcmplay playback ok. The user does not care whether trim lines live in stage1.config or a separate fragment.
Scope: kernel/gtaxllte-stage1.config. Next trim chunks (todo_trim_kernel_config_2026_10_23 stays open): the 382 pinned =y in kernel/gtaxllte-builtin.config, then defconfig =y ballast.
