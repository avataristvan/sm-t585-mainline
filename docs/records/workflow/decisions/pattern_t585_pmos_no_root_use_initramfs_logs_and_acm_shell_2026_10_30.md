id: pattern_t585_pmos_no_root_use_initramfs_logs_and_acm_shell_2026_10_30
type: pattern
area: workflow
perspective: agent
created: 1793346588.739978
edges: [{"target_id": "pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25", "edge_type": "related"}]
cue: A kernel or DT test leaves pmOS on the SM-T585 unable to mount root, blank screen, no ssh.
---

Rule: When a pmOS test boot cannot find its root partition, use the initramfs fail_halt_boot (after 30 s): it exposes a USB mass storage "PMOS_LOGS" (dmesg.txt, pmOS_init.txt, partitions, fdt.dtb), which udisks auto-mounts on the host, and a USB ACM debug shell on /dev/ttyACM0. Script commands over the ACM tty (the first connection prints a banner, resend). USB networking stays up, so send static tools with busybox `nc -l -p 9000 > /tmp/x` and bash /dev/tcp from the host. A static no-libc kernel/tools/memtool (clang --target=aarch64-linux-gnu -nostdlib -static -ffreestanding) gives register read/write there (initramfs busybox has no devmem, no python).
When: storage or DT changes break the root mount and there is no ssh.
Why: It is a shell and a log channel that come up without root; the memtool allows register inspection of the failing controller.
Evidence: S2 run 2026-10-30 (docs/emmc-speed-plan-2026-10-30.md)
