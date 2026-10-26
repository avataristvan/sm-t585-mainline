#!/bin/sh
# Alpine aarch64 rootfs as a squashfs, built on an x86_64 host without qemu:
# apk.static installs with --no-scripts, so the busybox applet links are made
# here from the package's /etc/busybox-paths.d list.
#   build.sh <work-dir> <out.sqfs>
# The device loads it into RAM (wget to /tmp, mount -o loop,ro, chroot) or,
# later, from the SD card.
set -eu

WORK=$1
OUT=$2
ALPINE=v3.24
MIRROR=https://dl-cdn.alpinelinux.org/alpine/$ALPINE
PACKAGES="alpine-base mesa-dri-gallium mesa-egl mesa-gbm kmscube libdrm-tests
	alsa-utils dropbear evtest e2fsprogs sdl3 eudev-libs"

# Downloads and the rootfs stay in separate directories.
DL=$WORK/dl
ROOT=$WORK/root
mkdir -p "$DL" "$(dirname "$OUT")"
rm -rf "$ROOT"
mkdir -p "$ROOT"/etc/apk

# Latest version of a package from the repository index
apkver() {
	curl -sfL "$MIRROR"/main/"$1"/APKINDEX.tar.gz | tar -xzO APKINDEX |
		sed -n "/^P:$2\$/{n;s/^V://p;q}"
}

if [ ! -x "$DL"/apk/sbin/apk.static ]; then
	V=$(apkver x86_64 apk-tools-static)
	curl -sfL -o "$DL"/apk-tools-static.apk "$MIRROR"/main/x86_64/apk-tools-static-"$V".apk
	mkdir -p "$DL"/apk
	tar -xzf "$DL"/apk-tools-static.apk -C "$DL"/apk sbin/apk.static 2>/dev/null
fi
if [ ! -d "$DL"/keys/etc/apk/keys ]; then
	V=$(apkver aarch64 alpine-keys)
	curl -sfL -o "$DL"/alpine-keys.apk "$MIRROR"/main/aarch64/alpine-keys-"$V".apk
	mkdir -p "$DL"/keys
	tar -xzf "$DL"/alpine-keys.apk -C "$DL"/keys 2>/dev/null
fi

cp -r "$DL"/keys/etc/apk/keys "$ROOT"/etc/apk/
printf '%s/main\n%s/community\n' "$MIRROR" "$MIRROR" > "$ROOT"/etc/apk/repositories
# shellcheck disable=SC2086
"$DL"/apk/sbin/apk.static --arch aarch64 --root "$ROOT" --initdb --usermode \
	--no-scripts --no-cache add $PACKAGES

# Busybox applet links, which the skipped busybox post-install would create
while read -r a; do
	[ -e "$ROOT/$a" ] || [ -L "$ROOT/$a" ] || ln -s /bin/busybox "$ROOT/$a"
done < "$ROOT"/etc/busybox-paths.d/busybox

# The kernel only has CONFIG_SQUASHFS_ZLIB. bin/bbsuid (mode 4111) is not
# readable as a user and not needed.
mksquashfs "$ROOT" "$OUT" -all-root -comp gzip -noappend -quiet -e bin/bbsuid
sha1sum "$OUT"
