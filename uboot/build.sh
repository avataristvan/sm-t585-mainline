#!/bin/sh
# Build mainline U-Boot (exynos-mobile) for the SM-T585 and pack it as an
# S-Boot boot image: uboot/out/u-boot-gtaxllte.img (flash to BOOT).
#
# Needs the GNU cross toolchain (pacman: aarch64-linux-gnu-gcc). Board DTS
# sources live in uboot/dts/ and are symlinked into the U-Boot tree (src/u-boot).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$HERE/../src/u-boot
BUILD=$HERE/build
OUT=$HERE/out

ln -sf "$HERE"/dts/exynos7870-gtaxllte.dts "$SRC"/dts/upstream/src/arm64/exynos/
ln -sf "$HERE"/dts/exynos7870-gtaxllte-u-boot.dtsi "$SRC"/arch/arm/dts/
# Board env (menu powers off when idle) selected by the gtaxllte.config fragment
ln -sf "$HERE"/env/gtaxllte.env "$SRC"/board/samsung/exynos-mobile/
ln -sf "$HERE"/gtaxllte.config "$SRC"/board/samsung/exynos-mobile/

MAKE="make -C $SRC O=$BUILD CROSS_COMPILE=aarch64-linux-gnu-"
$MAKE exynos-mobile_defconfig gtaxllte.config
$MAKE -j8 DEVICE_TREE=exynos/exynos7870-gtaxllte

mkdir -p "$OUT"
# S-Boot writes bootargs and memory into the DTB: leave room for it.
dtc -I dtb -O dtb -p 16384 -o "$OUT"/u-boot.dtb "$BUILD"/u-boot.dtb
python3 -I "$HERE"/../kernel/mkbootimg-gtaxllte.py \
	"$BUILD"/u-boot-nodtb.bin "$OUT"/u-boot.dtb /dev/null \
	"$OUT"/u-boot-gtaxllte.img
sha1sum "$OUT"/u-boot-gtaxllte.img
