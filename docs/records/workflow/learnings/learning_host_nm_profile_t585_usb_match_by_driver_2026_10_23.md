id: learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792791388.183191
edges: [{"target_id": "learning_host_nm_profile_t585_usb_bound_to_iface_name_2026_10_23", "edge_type": "supersedes"}, {"target_id": "learning_host_ncm_iface_name_changes_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23", "edge_type": "related"}]
cue: After a tablet reboot the host NCM NIC got a new name and NetworkManager no longer applies 172.16.42.2 via t585-usb.
---

Observed: The host NM profile t585-usb is now matched by driver instead of interface name: `nmcli con modify t585-usb connection.interface-name "" match.driver cdc_ncm connection.autoconnect-priority 10` (static 172.16.42.2/24). After a device reboot that re-enumerated the NIC, the profile came up automatically; no per-boot nmcli fix is needed any more. The auto-created "Kabelgebundene Verbindung 2" DHCP profile is also bound to an interface name; to revert, set interface-name back and clear match.driver.
Cause: The earlier profile was bound to an interface name that changes per USB port/re-enumeration.
Evidence: session 2026-10-23; refines learning_host_nm_profile_t585_usb_bound_to_iface_name_2026_10_23 and learning_host_ncm_iface_name_changes_2026_10_23.
