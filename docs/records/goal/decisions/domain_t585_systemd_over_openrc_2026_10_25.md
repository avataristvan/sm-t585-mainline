id: domain_t585_systemd_over_openrc_2026_10_25
type: domain
area: goal
perspective: user
created: 1792956332.466419
edges: [{"target_id": "domain_t585_pmos_ui_console_2026_10_25", "edge_type": "related"}]
cue: You choose the init system for the SM-T585 userspace and wonder whether it is systemd or OpenRC, and why.
---

Decision: The SM-T585 userspace runs systemd (postmarketOS edge, shown as "Nura edge"), not OpenRC. The user chose systemd over OpenRC on 2026-10-25.
Why: The user's choice; the session gives no further reason.
Scope: The pmOS userspace on the SM-T585 (pmos/device-samsung-gtaxllte, pmos/linux-samsung-gtaxllte). Installed as described in domain_t585_pmos_systemd_in_lineage_system_partition_2026_10_25.
