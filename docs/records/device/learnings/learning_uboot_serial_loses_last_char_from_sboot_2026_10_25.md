id: learning_uboot_serial_loses_last_char_from_sboot_2026_10_25
type: learning
area: device
perspective: agent
created: 1792963731.353565
edges: [{"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}]
cue: The fastboot serial number of the SM-T585 looks one character short compared to the real serial.
---

Observed: U-Boot's serial# taken from S-Boot's androidboot.serialno loses its last character; fastboot shows 33001155e80685f instead of ...685f3. Minor upstream bug.
Cause: strlcpy(buf, bootargs+offset, ret) copies ret-1 characters.
Evidence: fastboot getvar on hardware, 2026-10-25; see learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25.
