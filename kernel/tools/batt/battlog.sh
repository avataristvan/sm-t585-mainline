# Log SM5703 battery/charger state every N s to /tmp/batt.log and the fb console (tty0).
# On a wall charger (MUIC DEV_T1 = 0x40, DCP) it sets input/charge current to ILIM/ICHG
# via setchg.sh. Safety net: above MAXT (FG temperature, 0.1 C) the input limit drops
# to 100 mA and stays there.
# Usage: sh battlog.sh [interval_s] [maxt_decic] [ilim_mA ichg_mA] &
#        (needs /tmp/i2cx, /tmp/setchg.sh; stop: pkill -f battlog.sh)
IV=${1:-10}; MAXT=${2:-450}; ILIM=$3; ICHG=$4; LOG=/tmp/batt.log; HOT=0
busnr() {
	for d in /sys/bus/i2c/devices/i2c-*; do
		case $(readlink -f $d/..) in *$1.i2c) echo ${d##*-}; return ;; esac
	done
}
FG=$(busnr 13830000); MUIC=$(busnr 13850000); MFD=$(busnr 13870000)
rb() { /tmp/i2cx $1 $2 $3 r1 2>&1 | tail -1; }
fgw() { set -- $(/tmp/i2cx $FG 0x71 $1 r2 2>&1 | tail -1); echo $((0x$2$1)); }
mv() { echo $(( (($1 >> 8) & 7) * 1000 + ($1 & 255) * 1000 / 256 )); }
sg() { [ $(($1 & 0x8000)) -ne 0 ] && echo -n -; }

echo "# t_s vbat_mV curr_mA soc_% fgtemp_C soc_C muic chg_st3 vbus_st5 ilim_mA ichg_mA" >> $LOG
while :; do
	v=$(fgw 0x07); c=$(fgw 0x08); s=$(fgw 0x05); t=$(fgw 0x09)
	td=$(( ((t >> 8) & 127) * 10 + (t & 255) * 10 / 256 )); [ $((t & 0x8000)) -ne 0 ] && td=-$td
	vb=$(rb $MFD 0x49 0x0d)
	il=$(( 100 + (0x$vb & 0x3f) * 50 ))
	ic=$(( 100 + (0x$(rb $MFD 0x49 0x0f) & 0x3f) * 50 ))
	st=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
	mu=$(rb $MUIC 0x25 0x0a)
	l="$(cut -d. -f1 /proc/uptime) $(mv $v) $(sg $c)$(mv $c) $((s >> 8)).$(( (s & 255) * 10 / 256 )) $((td / 10)).$((td % 10)) $((st / 1000)) $mu $(rb $MFD 0x49 0x0a) $(rb $MFD 0x49 0x6b) $il $ic"
	if [ -n "$ILIM" ] && [ $HOT = 0 ] && [ "$mu" = 40 ] && [ $il != $ILIM -o $ic != $ICHG ]; then
		sh /tmp/setchg.sh $ILIM $ICHG >/dev/null 2>&1
		l="$l DCP->set$ILIM/$ICHG"
	fi
	if [ $td -gt $MAXT ] && [ $il -gt 100 ]; then
		HOT=1
		/tmp/i2cx $MFD 0x49 0x0d $(printf '0x%02x' $((0x$vb & 0xc0))) >/dev/null 2>&1
		l="$l HOT->ilim100"
	fi
	echo "$l" >> $LOG
	echo "$l" > /dev/tty0
	sleep $IV
done
