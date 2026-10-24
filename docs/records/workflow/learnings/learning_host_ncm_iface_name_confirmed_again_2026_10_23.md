id: learning_host_ncm_iface_name_confirmed_again_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792785321.369219
edges: [{"target_id": "learning_host_ncm_iface_name_changes_2026_10_23", "edge_type": "confirms"}]
cue: After a tablet reboot the host cannot reach 172.16.42.1 although the NCM interface came back under the same name.
---

Observed: After a reboot the host NCM interface was enp0s20f0u6 again, and the nmcli reassignment of 172.16.42.2/24 was needed again (NetworkManager does not keep it).
Cause: As in the earlier record: no DHCP server in stage 1 at that time (udhcpd was added later, see learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23).
Evidence: session 2026-10-23, audio chunk 3a; confirms learning_host_ncm_iface_name_changes_2026_10_23.
