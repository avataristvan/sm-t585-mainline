id: learning_t585_internet_via_ncm_host_nat_forward_2026_10_25
type: learning
area: workflow
perspective: agent
created: 1792924152.150209
edges: [{"target_id": "learning_claude_bang_prefix_no_sudo_root_commands_2026_10_25", "edge_type": "related"}, {"target_id": "learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23", "edge_type": "related"}, {"target_id": "learning_host_ncm_iface_name_changes_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_rootfs_image_made_on_device_no_usb_copy_2026_10_25", "edge_type": "related"}]
cue: You want the SM-T585 online through its USB link, and the host NAT rule alone still gives 100% packet loss.
---

Observed: The SM-T585 reaches the internet over the USB NCM link (device 172.16.42.1, host 172.16.42.2 on enp0s20f0u6, uplink wlan0), with no kernel change. The host needs NAT for 172.16.42.0/24 plus two iptables FORWARD accepts; the masquerade rule alone gave 100% packet loss. kernel/tools/host-nat.sh [uplink] applies it (run as root; idempotent; lasts until the host reboots). Verified 2026-10-25: ping 1.1.1.1 from the device 12 ms; `rootsh apk update` fetched 28570 packages; `apk add htop` installed into the rw rootfs image. Device side as set in kernel/initramfs/init: default route via 172.16.42.2, and /etc/resolv.conf in the rootfs (9.9.9.9, 1.1.1.1).
Cause: Docker on the host sets the iptables FORWARD policy to DROP, so forwarded packets from the NCM subnet are dropped even when nft masquerades them; the two FORWARD accepts (one per direction) open the path.
Evidence: kernel/tools/host-nat.sh (its header states the Docker cause); kernel/initramfs/init; session 2026-10-25 (ping and apk output on the device, not kept under docs/sources).
