#!/bin/sh
# Static aarch64 build of pwrkeyd against the kernel tree's nolibc and UAPI headers
# (run "make O=<build> ARCH=arm64 LLVM=1 headers" first).
#   build.sh <kernel-build-dir> <out>
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$HERE/../../../src/mainline
clang --target=aarch64-linux-gnu -Os -static -nostdlib -fno-stack-protector -fno-builtin -fuse-ld=lld \
	-include "$SRC"/tools/include/nolibc/nolibc.h \
	-I "$SRC"/tools/include/nolibc -I "$1"/usr/include \
	-o "$2" "$HERE"/pwrkeyd.c
