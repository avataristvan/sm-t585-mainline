# Dump RT5659 registers from the hardware (i2cx), one "reg: val" per line.
# Usage: sh hwdump.sh <out> [regs.txt]   (needs /tmp/i2cx; regs.txt = 3-digit hex list)
L=${2:-/tmp/alsa/regs.txt}
while read r; do
	r=$(printf '%04x' 0x$r)
	set -- $(/tmp/i2cx 2 0x1b 0x${r:0:2} 0x${r:2:2} r2 2>&1 | tail -1)
	echo "${r:1:3}: $1$2"
done < $L > $1
