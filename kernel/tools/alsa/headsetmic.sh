# Switch stage-1 capture from the main mic to the headset mic.
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/headsetmic.sh | sh
tinymix -D 0 set 'Main Mic Switch' 0
tinymix -D 0 set 'Headset Mic Switch' 1
