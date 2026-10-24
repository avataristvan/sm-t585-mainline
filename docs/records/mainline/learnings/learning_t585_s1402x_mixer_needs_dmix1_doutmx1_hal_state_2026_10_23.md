id: learning_t585_s1402x_mixer_needs_dmix1_doutmx1_hal_state_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792786743.235986
edges: [{"target_id": "learning_t585_s1402x_mixer_driver_works_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_downstream_multicodec_link_mixer_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_audio_roughness_volume_independent_open_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_capture_runs_realtime_use_pcmrec_i2s0_rx_zeros_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_s1402x_mixer_same_for_capture_and_playback_2026_10_24", "edge_type": "related"}]
cue: SM-T585 headphones are silent on mainline although DAPM, PLL1, I2S timing and pinmux all look right and the mixer driver probes fine.
---

Observed: Headphones stayed silent on mainline although the whole RT5659 DAPM path (AIF1RX -> DAC L1 -> HP Amp -> HPOL), PLL1 (MCLK 26 MHz), mixer sysclk 24.576 MHz, I2S0 timing (3 s in 2958 ms) and gpz1-0..3 pinmux (func 2) were verified. A register dump under Lineage (downstream 3.18, /d/regmap/14880000.s1402x/registers while Android played a sine to wired headphones) showed that the s1402x mixer needs DMIX1 (reg 0x10, offset 0x40) = 0x08 (MIX_EN1: channel 1 into the mixer, level 0) and DOUTMX1 (reg 0x16, offset 0x58) = 0x01 (DOUT_SEL1 = "AIF4IN"). The vendor audmixer_init_mixer() sets neither; the Android audio HAL sets them via mixer kcontrols during playback, so they are invisible when reading only the kernel driver. Other mixer differences (0x1c=0x04, 0x24=0x24) are BT/IN3 only. RT5659 power/clock registers under Lineage (0x61 8c80, 0x62 0400, 0x63 f23e, 0x65 0040, 0x70 8000, 0x80 4000) match ours; PLL regs differ (Lineage 0x81=1982 0x82=c000, ours 1903/9000), not yet evaluated.
Cause: Mixer routing state is HAL-set (mixer_paths), not driver-set. Fix applied, UNVERIFIED on hardware: both registers set in the init of src/mainline/sound/soc/samsung/s1402x-mixer.c.
Evidence: device-dump/sm-t585-audio-ref/{idle,play}-14880000.s1402x.txt, play-5-001b.txt, play-tinymix.txt.
