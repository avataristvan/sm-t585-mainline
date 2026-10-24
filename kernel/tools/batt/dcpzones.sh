# Wait for a DCP cable, then step the zones via temp_offset; log to /tmp/dcp.log and tty0.
# Usage: sh dcpzones.sh &
C=/sys/class/power_supply/sm5703-charger; F=/sys/class/power_supply/sm5703-fuel-gauge
P=/sys/module/sm5703_charger/parameters/temp_offset; LOG=/tmp/dcp.log
out() { echo "$1" >> $LOG; echo "$1" > /dev/tty0; }
out "dcpzones: waiting for DCP"
until grep -q '\[DCP\]' $C/usb_type; do sleep 2; done
for o in 0 -100 0 180 0; do
	echo $o > $P; sleep 15
	out "off=$o $(cat $C/health) $(cat $C/status | tr ' ' _) ilim=$(( $(cat $C/input_current_limit) / 1000 )) ichg=$(( $(cat $C/constant_charge_current) / 1000 )) float=$(( $(cat $C/constant_charge_voltage) / 1000 )) fg_i=$(( $(cat $F/current_now) / 1000 ))mA"
done
echo 0 > $P
out "dcpzones: done, back to the PC"
