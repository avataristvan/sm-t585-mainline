#!/bin/sh
# Wipe an SD card and put the rootfs squashfs on it, unpacked into an ext4
# partition labelled gtaxl-root (16 GiB; the rest stays unallocated).
# DESTROYS everything on <dev>. Run as root on the host:
#   write-sd.sh <dev> <rootfs.sqfs>
set -eu

DEV=$1
SQFS=$2
MNT=$(mktemp -d)

[ -b "$DEV" ] || { echo "$DEV is not a block device" >&2; exit 1; }
# Only removable-sized cards, never a system disk
SIZE=$(blockdev --getsize64 "$DEV")
[ "$SIZE" -le $((256 * 1024 * 1024 * 1024)) ] || { echo "$DEV is larger than 256 GiB" >&2; exit 1; }
lsblk -rno MOUNTPOINTS "$DEV" | grep -qx '/' && { echo "$DEV holds /" >&2; exit 1; }

lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS "$DEV"
printf 'Wipe %s? Type yes: ' "$DEV"
read -r ok
[ "$ok" = yes ] || exit 1

for p in $(lsblk -rno PATH "$DEV" | tail -n +2); do
	umount "$p" 2>/dev/null || true
	wipefs -a "$p"
done
wipefs -a "$DEV"
echo 'label: dos
start=2048, size=16GiB, type=83' | sfdisk --wipe always --wipe-partitions always "$DEV"
blockdev --rereadpt "$DEV"
udevadm settle

case $DEV in
*[0-9]) PART=${DEV}p1 ;;
*) PART=${DEV}1 ;;
esac
# A worn card can drop writes silently: check that the new table took.
[ "$(blockdev --getsize64 "$PART")" -eq $((16 * 1024 * 1024 * 1024)) ] ||
	{ echo "$PART is not 16 GiB after the reread: table not written?" >&2; exit 1; }
# mkfs.ext4 leaves the first 1 KiB alone, so an old FAT/exFAT boot sector
# would survive; wipe it and mount with an explicit type.
wipefs -a "$PART"
mkfs.ext4 -F -L gtaxl-root "$PART"
mount -t ext4 "$PART" "$MNT"
unsquashfs -f -d "$MNT" "$SQFS"
sync
umount "$MNT"
rmdir "$MNT"
echo "done: $PART (gtaxl-root)"
