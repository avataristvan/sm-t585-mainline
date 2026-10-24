# Switch stage-1 audio from headphones to the speakers.
# Usage on device: wget -qO- http://172.16.42.2:8000/alsa/speaker.sh | sh
tinymix -D 0 set 'Headphone Switch' 0
tinymix -D 0 set 'Speaker Switch' 1
