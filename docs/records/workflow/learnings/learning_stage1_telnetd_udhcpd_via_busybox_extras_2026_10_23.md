id: learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792791387.984432
edges: [{"target_id": "learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23", "edge_type": "supersedes"}, {"target_id": "todo_stage1_telnetd_udhcpd_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_tinymix_needs_musl_loader_2026_10_23", "edge_type": "related"}]
cue: You want telnet or DHCP on the SM-T585 stage-1 initramfs, or telnetd/udhcpd are silently missing after a boot-image rebuild.
---

Observed: telnetd and udhcpd now run from boot in stage 1. Solution: Alpine v3.23 busybox-extras 1.37.0-r30 (aarch64, dynamic musl, 130 KB; applets: telnetd udhcpd httpd tftpd ftpd inetd telnet tftp ...) plus the musl loader, both stored in kernel/prebuilt/alpine/ and packed by kernel/build-stage1.sh into the initramfs (/bin/busybox-extras, /lib/ld-musl-aarch64.so.1, symlink /lib/libc.musl-aarch64.so.1). kernel/initramfs/init calls `busybox-extras udhcpd` and `busybox-extras telnetd -b 172.16.42.1 -l /bin/sh`. Boot image sha1 5314dcc0d80eb2784b4ad7b572ffe077a65a68db (kernel #9 + i2s0 DTS fix + this initramfs, 20.9 MB), flashed and verified; after reboot `telnet 172.16.42.1` works with no manual step. busybox-extras httpd/tftpd are available for future file transfers.
Cause: Before, plain udhcpd/telnetd were silently missing from the static busybox; init sent errors to /dev/null. The applets live only in Alpine's busybox-extras.
Evidence: kernel/build-stage1.sh, kernel/initramfs/init, kernel/prebuilt/alpine/; boot image sha1 above; resolves todo_stage1_telnetd_udhcpd_2026_10_23.
