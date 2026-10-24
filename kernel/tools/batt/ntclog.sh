# Log battery NTC vs FG temperature and charger state every N s to /tmp/ntc.log and tty0.
# Usage: sh ntclog.sh [interval_s] &   (stop: pkill -f ntclog.sh)
IV=${1:-10}; LOG=/tmp/ntc.log
C=/sys/class/power_supply/sm5703-charger; F=/sys/class/power_supply/sm5703-fuel-gauge
echo "# t_s ntc_C fgtemp_C soc_C curr_mA soc_% health status usb ilim_mA ichg_mA float_mV" >> $LOG
while :; do
	n=$(cat /sys/class/thermal/thermal_zone1/temp)
	t=$(/tmp/i2cx 1 0x71 0x09 r2 2>&1 | tail -1); set -- $t
	w=$((0x$2$1)); fg=$(( ((w >> 8) & 127) ))
	l="$(cut -d. -f1 /proc/uptime) $((n / 1000)).$(( (n % 1000) / 100 )) $fg $(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 )) $(( $(cat $F/current_now) / 1000 )) $(cat $F/capacity) $(cat $C/health) $(cat $C/status | tr ' ' _) $(sed 's/.*\[\(.*\)\].*/\1/' $C/usb_type) $(( $(cat $C/input_current_limit) / 1000 )) $(( $(cat $C/constant_charge_current) / 1000 )) $(( $(cat $C/constant_charge_voltage) / 1000 ))"
	echo "$l" >> $LOG
	echo "$l" > /dev/tty0
	sleep $IV
done
