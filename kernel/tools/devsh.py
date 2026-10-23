"""Run one shell command on the stage-1 device via /dev/ttyACM0 (host cdc_acm).

    devsh.py "<command>" [seconds-to-read]

No pyusb needed, unlike acm-shell.py; requires the cdc_acm host module.
"""
import glob, os, sys, termios, time, select

# The device re-enumerates as ttyACM1 when ttyACM0 is still held after a reboot
fd = os.open(sorted(glob.glob("/dev/ttyACM*"))[0], os.O_RDWR | os.O_NOCTTY)
a = termios.tcgetattr(fd)
a[0] = a[1] = a[3] = 0
a[6][termios.VMIN] = a[6][termios.VTIME] = 0
termios.tcsetattr(fd, termios.TCSANOW, a)

def drain(t):
    out, end = b"", time.time() + t
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.2)
        if r:
            out += os.read(fd, 4096)
    return out

drain(0.3)
os.write(fd, (sys.argv[1] + "\n").encode())
sys.stdout.write(drain(float(sys.argv[2]) if len(sys.argv) > 2 else 2).decode(errors="replace"))
