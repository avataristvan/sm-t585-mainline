"""Receive the stage-1 remote syslog (busybox syslogd -R) and append it to a file."""
import socket, sys, time
path = sys.argv[1]
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(("172.16.42.2", 5514))
with open(path, "a", buffering=1) as f:
    while True:
        data, _ = s.recvfrom(65535)
        f.write(time.strftime("%H:%M:%S ") + data.decode(errors="replace").rstrip("\n") + "\n")
