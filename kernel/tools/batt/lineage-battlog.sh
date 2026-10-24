# Lineage reference log: what the downstream SM5703 drivers set per charger type.
# Run as root under Lineage: adb push i2cx /data/local/tmp/; adb shell
#   nohup sh /data/local/tmp/lineage-battlog.sh [interval_s] >/dev/null 2>&1 &
# Output: /data/local/tmp/batt.log (one line per tick, full MUIC/MFD dump on change).
# Skips the read-to-clear interrupt registers (MUIC 0x03-0x04, MFD 0x00-0x03).
IV=${1:-10}; X=/data/local/tmp/i2cx; LOG=/data/local/tmp/batt.log
busnr() {
	for d in /sys/bus/i2c/devices/i2c-*; do
		case $(readlink -f $d/..) in *$1*) echo ${d##*-}; return ;; esac
	done
}
FG=$(busnr 13830000); MUIC=$(busnr 13850000); MFD=$(busnr 13870000)
B=/sys/class/power_supply/battery
p() { cat $1 2>/dev/null || echo -; }
C=/sys/class/power_supply/sm5703-charger
echo "# buses fg=$FG muic=$MUIC mfd=$MFD" >> $LOG
echo "# t_s status charge_type online cap_% volt_uV curr_now_mA curr_avg batt_temp chg_in_max chg_cur_now | fg05-09 | mfd0c-13 st08-0b st6b | muic07 muic0a" >> $LOG
OLD=
while :; do
	fg=$($X $FG 0x71 0x05 r10 2>&1 | tail -1)
	mfd=$($X $MFD 0x49 0x0c r8 2>&1 | tail -1)
	st=$($X $MFD 0x49 0x08 r4 2>&1 | tail -1)
	s5=$($X $MFD 0x49 0x6b r1 2>&1 | tail -1)
	mu=$($X $MUIC 0x25 0x05 r27 2>&1 | tr '\n' ' ')
	set -- $mu
	echo "$(cut -d. -f1 /proc/uptime) $(p $B/status) $(p $B/charge_type) $(p $B/online) $(p $B/capacity) $(p $B/voltage_now) $(p $B/current_now) $(p $B/current_avg) $(p $B/batt_temp) $(p $C/current_max) $(p $C/current_now) | $fg | $mfd $st $s5 | $3 $6" >> $LOG
	if [ "$mu$mfd" != "$OLD" ]; then
		echo "# MUIC 05-1f: $mu" >> $LOG
		echo "# MFD 04-7f: $($X $MFD 0x49 0x04 r124 2>&1 | tr '\n' ' ')" >> $LOG
		OLD="$mu$mfd"
	fi
	sleep $IV
done
