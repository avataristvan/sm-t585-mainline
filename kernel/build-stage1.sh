#!/bin/sh
# Build the stage-1 boot.img for the SM-T585 from an already built kernel.
#
#   build-stage1.sh <kernel-out-dir> <static-aarch64-busybox> <out-dir>
set -eu

KOUT=$1
BUSYBOX=$2
OUT=$3
HERE=$(cd "$(dirname "$0")" && pwd)

mkdir -p "$OUT"

# gen_init_cpio (from the kernel build) can create /dev/console without root,
# which the kernel opens before /init runs.
cat > "$OUT"/initramfs.list <<EOF
dir /bin 755 0 0
dir /dev 755 0 0
dir /etc 755 0 0
dir /proc 755 0 0
dir /sys 755 0 0
dir /tmp 1777 0 0
nod /dev/console 600 0 0 c 5 1
file /bin/busybox $BUSYBOX 755 0 0
file /init $HERE/initramfs/init 755 0 0
dir /lib 755 0 0
file /lib/ld-musl-aarch64.so.1 $HERE/prebuilt/alpine/ld-musl-aarch64.so.1 755 0 0
slink /lib/libc.musl-aarch64.so.1 ld-musl-aarch64.so.1 777 0 0
file /bin/busybox-extras $HERE/prebuilt/alpine/busybox-extras-1.37.0-r30-aarch64 755 0 0
EOF
"$KOUT"/scripts/gen_init_cpio "$OUT"/initramfs.list | gzip -9 > "$OUT"/initramfs.cpio.gz

# Leave room for the properties S-Boot writes into the DTB (bootargs, initrd,
# memory, serial).
dtc -I dtb -O dtb -p 16384 -o "$OUT"/gtaxllte.dtb \
	"$KOUT"/arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dtb

python3 -I "$HERE"/mkbootimg-gtaxllte.py \
	"$KOUT"/arch/arm64/boot/Image "$OUT"/gtaxllte.dtb \
	"$OUT"/initramfs.cpio.gz "$OUT"/boot-stage1.img \
	"console=tty0 console=ttySAC2,115200 loglevel=7"
