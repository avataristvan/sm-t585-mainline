id: todo_t585_package_linux_r9_dsi_reenable_remove_blank_never_2026_10_29
type: todo
area: mainline
perspective: user
created: 1793307031.330406
edges: [{"target_id": "learning_t585_dsim_video_mode_state_before_panel_commands_reenable_fixed_2026_10_29", "edge_type": "derived_from"}, {"target_id": "todo_t585_report_dsi_findings_to_kaustabh_2026_10_26", "edge_type": "related"}]
cue: You finish the DSI re-enable fix and the tablet still runs a test kernel with panic=5 and GNOME Blank Screen set to Never.
---

TODO: Build and install linux-samsung-gtaxllte r9 with src/mainline 273a0b9d8 + 4ac46feab. This resets /boot/vmlinuz and removes panic=5 from pmos.conf. Then remove the interim GNOME "Blank Screen: Never".
