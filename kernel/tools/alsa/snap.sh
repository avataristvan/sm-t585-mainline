# Snapshot audio state during playback: sh snap.sh <tag>  -> /tmp/snap-<tag>/
T=/tmp/snap-$1; mkdir -p $T; cd /tmp/alsa
(pcmplay /dev/snd/pcmC0D0p sine48k.wav > $T/play.txt 2>&1 &)
sleep 1
cat /sys/kernel/debug/regmap/2-001b/registers > $T/codec.txt
cat /sys/kernel/debug/regmap/14880000.audio-mixer/registers > $T/mixer.txt
cd /sys/kernel/debug/asoc/SM-T585
for f in dapm/* */dapm/*; do echo "$f: $(head -1 "$f")"; done > $T/dapm.txt
# memtool <addr> reads; a second argument would WRITE
for o in 00 04 08 0c 10 14 18 1c 20 24 28 2c 30 34 38 3c; do /tmp/memtool 0x148a00$o; done > $T/i2s0.txt 2>&1
sleep 3; cat $T/play.txt
