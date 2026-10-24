id: learning_t585_lineage_capture_dump_procedure_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792824546.26207
edges: [{"target_id": "learning_t585_main_mic_in3_micbias2_lineage_ref_2026_10_24", "edge_type": "related"}, {"target_id": "learning_t585_speaker_dump_lineage_reference_and_roundtrip_2026_10_24", "edge_type": "related"}]
cue: You need a Lineage reference dump of the SM-T585 during microphone capture, or must move a file off the stage-1 device.
---

Observed: Lineage capture-dump procedure: script kernel/out/alsa/lineage-capdump.sh <tag> (codec + s1402x regmap, tinymix, capture PCM status into /data/local/tmp/cap-<tag>/). Recorder app org.lineageos.recorder: `pm grant` RECORD_AUDIO, `am start -n org.lineageos.recorder/.RecorderActivity`, tap the record button at 600,1740 via adb input. Dump only after /proc/asound/card0/pcm0c/sub0/status shows RUNNING (an early dump caught the idle state).
Limits: no /dev/mem under Lineage, so I2S0 registers cannot be read there (toybox devmem width is in bytes).
Stage-1 file transfer to host: host `nc -l -s 172.16.42.2 -p 9000 > f`, device `nc 172.16.42.2 9000 < f`.
Evidence: session 2026-10-24; device-dump/sm-t585-audio-ref/lineage-cap-mainmic/.
