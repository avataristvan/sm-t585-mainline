id: learning_stage1_flash_via_ncm_wget_verified_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792770177.031708
edges: [{"target_id": "learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_flash_via_ncm_wget_unverified_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}, {"target_id": "learning_http_server_poll_before_device_wget_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_tmp_is_tmpfs_refetch_modules_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_devsh_for_all_device_commands_2026_10_23", "edge_type": "related"}]
cue: You iterate kernel builds on the SM-T585 and want to flash a new image without TWRP while stage 1 is running.
---

Observed: Flashing a new boot image over NCM works (exercised 2026-10-23 with the touch image, sha1 f5c26836...). Procedure: the PC serves kernel/out with python http.server bound to 172.16.42.2; the device runs busybox wget into /tmp, checks sha1, dd's to /dev/mmcblk0p9 (mainline has no /dev/block/; PARTNAME=BOOT verified via sysfs), reads back the first N bytes and compares the hash, then reboot -f.
Cause: the USB NCM gadget works and busybox wget/dd are in the initramfs.
Evidence: boot/flash session 2026-10-23; supersedes learning_stage1_flash_via_ncm_wget_unverified_2026_10_23; host setup in learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23.
