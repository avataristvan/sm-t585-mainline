# Both mics as separate tracks: left = main mic, right = headset mic.
# Needs the machine module loaded with jack_switch=0, else the jack overrides.
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/bothmics.sh | sh
tinymix -D 0 set 'Main Mic Switch' 1
tinymix -D 0 set 'Headset Mic Switch' 1
