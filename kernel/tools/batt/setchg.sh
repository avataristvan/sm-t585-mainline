# Set SM5703 input current limit and fast-charge current by hand (test only, no driver).
# Usage: sh setchg.sh <input_mA> <charge_mA>   (100..1500, 50 mA steps; needs /tmp/i2cx)
for d in /sys/bus/i2c/devices/i2c-*; do
	case $(readlink -f $d/..) in *13870000.i2c) MFD=${d##*-} ;; esac
done
cl() { [ $1 -lt 100 ] && echo 100 && return; [ $1 -gt 1500 ] && echo 1500 && return; echo $1; }
IL=$(cl $1); IC=$(cl $2)
vb=$(/tmp/i2cx $MFD 0x49 0x0d r1 2>&1 | tail -1)
/tmp/i2cx $MFD 0x49 0x0d $(printf '0x%02x' $(( (0x$vb & 0xc0) | (IL - 100) / 50 )))
/tmp/i2cx $MFD 0x49 0x0f $(printf '0x%02x' $(( (IC - 100) / 50 )))
echo "0x0d=$(/tmp/i2cx $MFD 0x49 0x0d r1 2>&1 | tail -1) 0x0f=$(/tmp/i2cx $MFD 0x49 0x0f r1 2>&1 | tail -1)"
