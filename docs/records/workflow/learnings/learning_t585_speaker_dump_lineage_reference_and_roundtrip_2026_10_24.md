id: learning_t585_speaker_dump_lineage_reference_and_roundtrip_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792820997.109255
edges: [{"target_id": "learning_t585_speaker_silent_dac_mux_stereo_dac_mixer_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_dump_downstream_regmap_when_port_silent_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_lineage_capture_dump_procedure_2026_10_24", "edge_type": "related"}]
cue: You need a working Lineage register state of the SM-T585 to diff against mainline, or must switch between Lineage and stage 1 boot.
---

Observed: Lineage speaker reference dumps exist: device-dump/sm-t585-audio-ref/lineage-spk-play-5-001b.txt (RT5659), lineage-spk-play-14880000.s1402x.txt, lineage-spk-play-tinymix.txt; mainline counterpart mainline-spk-play-2-001b.txt.
Procedure under Lineage: push the wav to /sdcard/Music, `cmd media_session volume --stream 3 --set 7`, `am start -a android.intent.action.VIEW -d file:///sdcard/Music/sine15.wav -t audio/wav` (org.lineageos.eleven plays it), then `cat /d/regmap/5-001b/registers`.
Round trip: from stage 1 flash the Lineage boot (wget boot-lineage.img, dd, check sha1 d4352320...), adb root under Lineage; return with `adb push kernel/out/boot-stage1.img /data/local/tmp/`, dd to /dev/block/mmcblk0p9, then `head -c <size> | sha1sum` to verify. The user runs the dd via "!".
Cause: n/a (reference material and procedure).
Evidence: device-dump/sm-t585-audio-ref/ files named above; pattern_dump_downstream_regmap_when_port_silent_2026_10_23.
