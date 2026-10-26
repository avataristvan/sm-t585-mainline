id: domain_t585_uboot_env_bootmenu_timeout_power_off_2026_10_26
type: domain
area: device
perspective: agent
created: 1792971054.647674
edges: [{"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}, {"target_id": "learning_t585_twrp_usb_missing_after_uboot_hang_empty_battery_2026_10_25", "edge_type": "derived_from"}]
cue: U-Boot sits idle on the SM-T585 with the screen on and the battery drains, or you wonder why bootcmd ends in bootmenu.
---

Decision: U-Boot env override uboot/env/gtaxllte.env, selected by fragment uboot/gtaxllte.config (CONFIG_ENV_SOURCE_FILE="gtaxllte"): bootcmd "bootefi bootmgr; bootmenu" (upstream had "pause", which waits forever), bootmenu_delay=60, bootmenu_default=4 (Power Off).
Why: U-Boot has no charger driver, so an idle U-Boot with the screen on drains the battery. This happened 2026-10-25: the battery was not even shown in TWRP until recharged on a wall charger (then back at 33 %). With the timeout the device powers off after 60 s of idle menu.
Scope: Our U-Boot build (uboot/). Fastboot mode still has no timeout, so do not leave the device in fastboot.
