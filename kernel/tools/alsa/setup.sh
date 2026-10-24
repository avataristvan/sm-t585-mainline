# Stage-1 audio debug setup after a reboot: test WAVs and debug tools.
# The audio modules and tinymix/pcmplay/pcmrec come with the initramfs; the
# routing defaults are set by the machine driver.
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/setup.sh | sh
H=http://172.16.42.2:8000
mkdir -p /tmp/alsa
cd /tmp/alsa
for f in sine48k.wav sine-fade.wav regs.txt; do
	wget -q $H/alsa/$f
done
for f in memtool i2cx; do
	wget -qO /tmp/$f $H/$f && chmod +x /tmp/$f
done
mount -t debugfs none /sys/kernel/debug 2>/dev/null
cat /proc/asound/cards
