# Lineage reference dump during a running recording: sh lineage-capdump.sh <tag>
# Run as root under Lineage (adb root; adb shell) while the Recorder app records.
# Output: /data/local/tmp/cap-<tag>/
T=/data/local/tmp/cap-$1; mkdir -p $T
cat /d/regmap/5-001b/registers > $T/codec.txt
cat /d/regmap/14880000.s1402x/registers > $T/mixer.txt 2>/dev/null ||
	cat /d/regmap/*s1402x*/registers > $T/mixer.txt
tinymix > $T/tinymix.txt 2>&1
cat /proc/asound/pcm > $T/pcm.txt
for f in /proc/asound/card0/pcm*c/sub0/hw_params /proc/asound/card0/pcm*c/sub0/status; do
	echo "== $f"; cat $f
done > $T/cap-pcm.txt 2>&1
ls -l $T
