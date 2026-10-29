id: domain_t585_no_custom_power_key_console_handling_2026_10_29
type: domain
area: goal
perspective: user
created: 1793307031.089598
edges: [{"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "derived_from"}, {"target_id": "learning_t585_unexplained_s2idle_suspend_after_boot_never_resumed_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_gnome_mobile_power_key_blank_not_suspend_logind_ignore_2026_10_28", "edge_type": "related"}, {"target_id": "todo_t585_s2idle_resume_debug_plan_charger_poll_fix_rtcwake_2026_10_29", "edge_type": "related"}]
cue: You want the SM-T585 power key to blank the screen on the text console, outside GNOME.
---

Decision: No custom power-key handling for the text console (user, agent advised). Use the standard routes: idle blanking (consoleblank= / setterm --blank) and, once s2idle resume works, HandlePowerKey=suspend.
Why: logind HandlePowerKey has no "blank display" action. A daemon toggling fb0/blank (like the stage-1 pwrkeyd) would be non-standard and would fight GNOME.
Scope: SM-T585 pmOS without a GNOME session. HandlePowerKey=suspend waits for todo_t585_find_s2idle_suspend_trigger_2026_10_29.
