# Read the SM5703 fuel gauge, charger (MFD) and MUIC raw via i2cx, decoded where known.
# Usage: sh rawdump.sh   (needs /tmp/i2cx; read-only)
busnr() {
	for d in /sys/bus/i2c/devices/i2c-*; do
		case $(readlink -f $d/..) in *$1.i2c) echo ${d##*-}; return ;; esac
	done
}
FG=$(busnr 13830000); MUIC=$(busnr 13850000); MFD=$(busnr 13870000)
echo "buses: fg=$FG muic=$MUIC mfd=$MFD"

# FG words are little-endian (i2c block read into u16)
fgw() { set -- $(/tmp/i2cx $FG 0x71 $1 r2 2>&1 | tail -1); echo $((0x$2$1)); }
fx() { printf '0x%04x' $(fgw $1); }
v=$(fgw 0x07); o=$(fgw 0x06); c=$(fgw 0x08); t=$(fgw 0x09); s=$(fgw 0x05)
mv() { echo $(( (($1 >> 8) & 7) * 1000 + ($1 & 255) * 1000 / 256 )); }
sg() { [ $(($1 & 0x8000)) -ne 0 ] && echo -n -; }
echo "FG id=$(fx 0x00) cntl=$(fx 0x01) op_status=$(fx 0x10) (low byte 0x07 = initialised, DISABLE_RE_INIT)"
echo "FG vbat=$(mv $v) mV  ocv=$(mv $o) mV  curr=$(sg $c)$(mv $c) mA"
echo "FG soc=$(( (s >> 8) )).$(( (s & 255) * 10 / 256 )) %  temp=$(sg $t)$(( (t >> 8) & 127 )).$(( (t & 255) * 10 / 256 )) C"

echo "MFD id(0x1e)=$(/tmp/i2cx $MFD 0x49 0x1e r1 2>&1 | tail -1)"
echo "MFD status1-4 (0x08): $(/tmp/i2cx $MFD 0x49 0x08 r4 2>&1 | tail -1)"
echo "MFD status5 (0x6b): $(/tmp/i2cx $MFD 0x49 0x6b r1 2>&1 | tail -1)  (0x20 VBUSOK, 0x40 UVLO, 0x80 OVP)"
echo "MFD cntl..chgcntl6 (0x0c-0x13): $(/tmp/i2cx $MFD 0x49 0x0c r8 2>&1 | tail -1)"
echo "  (0x0d & 0x3f: input limit 100+50n mA; 0x0f: fast charge 100+50n mA; 0x10 & 0x1f: float 4120+10n mV)"
echo "MUIC 0x00-0x1f (0x07 ADC, 0x0a DEV_T1: 0x04 USB, 0x20 CDP, 0x40 DCP):"; /tmp/i2cx $MUIC 0x25 0x00 r32 2>&1
