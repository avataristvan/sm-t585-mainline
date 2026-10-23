id: learning_host_nm_profile_t585_usb_bound_to_iface_name_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792789907.819698
superseded_by: learning_host_nm_profile_t585_usb_match_by_driver_2026_10_23
valid_until: 1792791389.411281
edges: [{"target_id": "learning_host_ncm_iface_name_changes_2026_10_23", "edge_type": "related"}]
cue: After a tablet reboot the host lost 172.16.42.2 and the device wget fails, though NetworkManager has a t585-usb profile.
---

Observed: After a device reboot the host USB-NCM NIC can re-enumerate under another name (enp0s20f0u5 vs u6). The NM profile t585-usb is bound to an interface name, so the host loses 172.16.42.2 and device wget fails.
Cause: connection.interface-name no longer matches the new NIC name.
Fix: nmcli con modify t585-usb connection.interface-name <current-if>; nmcli con up t585-usb. (Changed to enp0s20f0u6 on 2026-10-23.)
Evidence: session 2026-10-23; refines learning_host_ncm_iface_name_changes_2026_10_23.
