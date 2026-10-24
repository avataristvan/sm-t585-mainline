# Reload codec + machine modules from the host (after rebuilding them).
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/reload.sh | sh [-s -- machine args]
H=http://172.16.42.2:8000
mkdir -p /tmp/snd
rmmod snd_soc_gtaxllte_rt5659 snd_soc_rt5659
for f in snd-soc-rt5659.ko snd-soc-gtaxllte-rt5659.ko; do
	wget -qO /tmp/snd/$f $H/snd/$f
done
insmod /tmp/snd/snd-soc-rt5659.ko
insmod /tmp/snd/snd-soc-gtaxllte-rt5659.ko "$@"
sleep 1
cat /proc/asound/cards
