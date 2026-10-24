# Compare RT5659 hardware (i2cx) against the regmap cache while playing.
# Usage: sh hwcmp.sh   (needs /tmp/i2cx)
cd /tmp/alsa
(pcmplay /dev/snd/pcmC0D0p sine48k.wav > /dev/null 2>&1 &)
sleep 0.5
R=/sys/kernel/debug/regmap/2-001b/registers
for r in 002 019 02a 02d 061 062 063 064 065 066 067 06b 070 073 080 081 082 083 084 085 08a 0fa 110 111; do
	c=$(grep "^$r:" $R | cut -d' ' -f2)
	h=$(/tmp/i2cx 2 0x1b 0x0${r:0:1} 0x${r:1:2} r2 2>&1 | tail -1)
	echo "$r cache=$c hw=$h"
done
