id: learning_host_ncm_iface_name_changes_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792778220.052395
edges: [{"target_id": "learning_host_ncm_iface_name_confirmed_again_2026_10_23", "edge_type": "related"}, {"target_id": "learning_host_nm_profile_t585_usb_bound_to_iface_name_2026_10_23", "edge_type": "related"}, {"target_id": "learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23", "edge_type": "related"}]
cue: The host cannot reach the tablet at 172.16.42.1 after a replug and the NCM interface has a new name or a link-local address.
---

Observed: The host USB NCM interface name changes per port and replug (enp0s20f0u5 / u2 / u6). NetworkManager falls back to link-local. Fix: `nmcli device modify <iface> ipv4.method manual ipv4.addresses 172.16.42.2/24`.
Cause: Predictable names include the USB port path. At the time of writing stage 1 had no DHCP server, so NM auto-config found nothing; udhcpd has since been added (learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23), and the host side is now handled by a driver-matched NM profile (learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23).
Evidence: docs/handoff-2026-10-23.md, section "Update 2026-10-23 evening".
