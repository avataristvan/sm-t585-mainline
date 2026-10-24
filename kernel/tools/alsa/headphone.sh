# Switch stage-1 audio from the speakers back to headphones.
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/headphone.sh | sh
tinymix -D 0 set 'Speaker Switch' 0
tinymix -D 0 set 'Headphone Switch' 1
