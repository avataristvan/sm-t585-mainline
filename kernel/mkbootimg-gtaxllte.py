#!/usr/bin/env python3
"""Pack a boot.img the way S-Boot on the SM-T585 (gtaxllte) expects it.

Layout mirrors the working LineageOS boot.img dumped from the device
(device-dump/sm-t585/partitions/boot.img): Android boot header v0, page size
2048, the header_version slot reused as dt_size, a Samsung DTBH container as
the "dt" section after the ramdisk, and a SEANDROIDENFORCE trailer.

S-Boot picks a DTB from the DTBH table by chip/platform/subtype/hw_rev, so the
single entry here covers every board revision (0..0xff).

Usage: mkbootimg-gtaxllte.py <Image> <dtb> <initramfs> <out.img> [cmdline]
"""
import hashlib
import struct
import sys

PAGE = 2048

# Values from the device's own DTBH table (all five entries share them).
DTBH_CHIP = 7870
DTBH_PLATFORM = 0x50A6
DTBH_SUBTYPE = 0x217584DA
DTBH_SPACE = 32

KERNEL_ADDR = 0x10008000
RAMDISK_ADDR = 0x11000000
TAGS_ADDR = 0x10000100
OS_VERSION = 0x1C00018B  # copied from the working image


def pad(data, align=PAGE):
    return data + b"\0" * (-len(data) % align)


def dtbh(dtb):
    entries = 1
    header = struct.pack("<4sII", b"DTBH", 2, entries)
    offset = PAGE
    entry = struct.pack("<8I", DTBH_CHIP, DTBH_PLATFORM, DTBH_SUBTYPE,
                        0, 0xFF, offset, len(pad(dtb)), DTBH_SPACE)
    return pad(header + entry) + pad(dtb)


def main():
    kernel_path, dtb_path, ramdisk_path, out_path = sys.argv[1:5]
    cmdline = sys.argv[5].encode() if len(sys.argv) > 5 else b""
    if len(cmdline) >= 512:
        sys.exit("cmdline too long")

    kernel = open(kernel_path, "rb").read()
    ramdisk = open(ramdisk_path, "rb").read()
    dt = dtbh(open(dtb_path, "rb").read())

    sha = hashlib.sha1()
    for blob in (kernel, ramdisk, b"", dt):
        sha.update(blob)
        sha.update(struct.pack("<I", len(blob)))

    header = struct.pack("<8s10I16s512s32s1024s", b"ANDROID!",
                         len(kernel), KERNEL_ADDR,
                         len(ramdisk), RAMDISK_ADDR,
                         0, 0, TAGS_ADDR, PAGE,
                         len(dt), OS_VERSION,
                         b"", cmdline, sha.digest(), b"")

    image = pad(header) + pad(kernel) + pad(ramdisk) + pad(dt)
    image += b"SEANDROIDENFORCE"
    with open(out_path, "wb") as f:
        f.write(image)
    print(f"{out_path}: {len(image)} bytes (kernel {len(kernel)}, "
          f"ramdisk {len(ramdisk)}, dt {len(dt)})")


if __name__ == "__main__":
    main()
