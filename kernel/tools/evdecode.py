#!/usr/bin/env python3
"""Decode a raw evdev capture (cat /dev/input/eventN > file) from the aarch64 device."""
import struct
import sys

TYPES = {0: "SYN", 1: "KEY", 3: "ABS"}
CODES = {
    1: {139: "KEY_MENU", 158: "KEY_BACK"},
    3: {0x2f: "MT_SLOT", 0x30: "MT_TOUCH_MAJOR", 0x31: "MT_TOUCH_MINOR", 0x34: "MT_ORIENTATION",
        0x35: "MT_POSITION_X", 0x36: "MT_POSITION_Y", 0x39: "MT_TRACKING_ID", 0x3a: "MT_PRESSURE",
        0x19: "DISTANCE"},
}

data = open(sys.argv[1], "rb").read()
for off in range(0, len(data) - 23, 24):
    sec, usec, typ, code, val = struct.unpack_from("<qqHHi", data, off)
    if typ == 0:
        print("-- SYN")
        continue
    name = CODES.get(typ, {}).get(code, hex(code))
    print(f"{sec}.{usec:06d} {TYPES.get(typ, typ)} {name} {val}")
