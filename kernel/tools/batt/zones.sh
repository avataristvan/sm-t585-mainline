# Swap in the freshly built charger module, then step the zones via temp_offset (SDP).
# Usage: sh zones.sh
cd /tmp; rm -f c.ko; wget -q -O c.ko http://172.16.42.2:8000/batt/sm5703_charger.ko; sha1sum c.ko
rmmod sm5703_charger; insmod c.ko; sleep 3
C=/sys/class/power_supply/sm5703-charger; P=/sys/module/sm5703_charger/parameters/temp_offset
echo "cap $(cat /sys/class/power_supply/sm5703-fuel-gauge/capacity) usb $(cat $C/usb_type)"
for o in 0 -100 0 180 300 230 200 0 -260 -220 0; do
  echo $o > $P; sleep 6
  echo "off=$o temp=$(cat $C/temp) $(cat $C/health) $(cat $C/status | tr ' ' _) ichg=$(( $(cat $C/constant_charge_current)/1000 )) float=$(( $(cat $C/constant_charge_voltage)/1000 ))"
done
dmesg | grep sm5703-charger | tail -12
