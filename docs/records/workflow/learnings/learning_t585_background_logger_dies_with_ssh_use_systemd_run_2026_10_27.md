id: learning_t585_background_logger_dies_with_ssh_use_systemd_run_2026_10_27
type: learning
area: workflow
perspective: agent
created: 1793051249.718683
edges: [{"target_id": "domain_private_access_details_not_in_public_records_2026_10_27", "edge_type": "related"}, {"target_id": "learning_t585_sm5703_fg_status_follows_charger_verified_hw_2026_10_26", "edge_type": "related"}, {"target_id": "pattern_t585_on_device_measurement_scripts_systemd_run_usb_unplugged_2026_10_30", "edge_type": "related"}]
cue: You start a background logger on the pmOS tablet over ssh for a user-driven hardware test and need it to survive the session.
---

Observed: On the pmOS tablet a background logger started via ssh with nohup/setsid dies when the ssh session ends (logind kills it). Run it as a transient unit instead: `systemd-run --uid=<user> --unit=NAME script` as root on the tablet (see CLAUDE.local.md). Running the script as root fails to write /tmp files owned by another user (fs.protected_regular). The tablet clock was ~26 s behind the host.
Cause: logind cleans up the session's processes; fs.protected_regular blocks root writes to other users' files in sticky /tmp.
Evidence: gauge/charger uevent logging, HW session 2026-10-26. Practice: give user-driven HW tests a generous logging window (15 min) rather than tight time slots.
