id: pattern_pmos_logs_via_pstore_and_losetup_journal_2026_10_25
type: pattern
area: workflow
perspective: agent
created: 1792956373.708088
edges: [{"target_id": "learning_t585_pstore_needs_printk8_in_init_2026_10_24", "edge_type": "related"}, {"target_id": "pattern_t585_pmos_no_root_use_initramfs_logs_and_acm_shell_2026_10_30", "edge_type": "related"}]
cue: postmarketOS on the SM-T585 does not reach ssh and you need its boot log or journal while the device has no shell.
---

Rule: When pmOS does not reach ssh, read its logs from stage 1 (the debug boot). (a) Boot-time kernel messages: read pstore. console-ramoops and pmsg-ramoops show the initramfs stages; TWRP's downstream kernel shows an empty pstore. (b) The journal: from stage 1, mount pmOS_root with losetup -r -o $((499712*512)) (busybox mount -o offset failed), serve system.journal with busybox-extras httpd, fetch it and read it with the host's journalctl --file.
When: pmOS is installed on the SM-T585 but no ssh answers.
Why: Stage 1 is the only shell that comes up when pmOS does not; pstore survives the reboot; busybox mount with an offset fails, so losetup is used.
