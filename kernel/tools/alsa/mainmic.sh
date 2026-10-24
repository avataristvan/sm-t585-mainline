# Switch stage-1 capture from the headset mic to the main mic.
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/mainmic.sh | sh
tinymix -D 0 set 'Headset Mic Switch' 0
tinymix -D 0 set 'Main Mic Switch' 1
