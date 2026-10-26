id: domain_t585_pmos_ui_gnome_mobile_2026_10_26
type: domain
area: goal
perspective: user
created: 1792973875.25019
edges: [{"target_id": "domain_t585_pmos_ui_console_2026_10_25", "edge_type": "supersedes"}, {"target_id": "domain_t585_pmos_in_userdata_pmaports_model_2026_10_26", "edge_type": "related"}]
cue: You choose or change the UI on the running postmarketOS of the SM-T585 (GNOME Mobile vs Phosh vs console).
---

Decision: The pmOS UI on the SM-T585 is GNOME Mobile, installed into the running pmOS with `apk add postmarketos-ui-gnome-mobile` (not a fresh image). User's choice, 2026-10-26.
Why: Phosh was considered; postmarketos-ui-phosh conflicts with gnome-shell-mobile / mutter-mobile / gnome-settings-daemon-mobile, so both cannot be installed together. The user chose GNOME Mobile.
Scope: pmOS userspace on the SM-T585. Observed after install: gdm active, usb-signaller active with default_mode="developer_mode" (USB networking stays), 160 MB RAM used at the gdm greeter. Replaces the console start (domain_t585_pmos_ui_console_2026_10_25).
