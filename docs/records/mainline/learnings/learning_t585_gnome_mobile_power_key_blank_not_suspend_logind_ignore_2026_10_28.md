id: learning_t585_gnome_mobile_power_key_blank_not_suspend_logind_ignore_2026_10_28
type: learning
area: mainline
perspective: agent
created: 1793226618.125097
edges: [{"target_id": "learning_t585_gnome_mobile_power_button_backlight_2026_10_26", "edge_type": "related"}]
cue: You wonder why the SM-T585 power key blanks instead of suspending, or does nothing when GNOME is not running.
---

Observed: GNOME Mobile does the system action 'blank' on a short power-key press, not suspend, whatever gsettings power-button-action 'suspend' says. postmarketos-base-systemd sets logind HandlePowerKey=ignore, so without a running GNOME session nothing reacts to the key.
Cause: GNOME Mobile's own handling replaces the gsd action; pmOS hands the key to the shell by ignoring it in logind.
Evidence: session 2026-10-28 on the device; refines learning_t585_gnome_mobile_power_button_backlight_2026_10_26.
