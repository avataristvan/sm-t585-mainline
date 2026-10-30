id: todo_t585_config_uhid_for_ble_hid_2026_10_30
type: todo
area: mainline
perspective: agent
created: 1793377380.784401
cue: You pair a Bluetooth keyboard or mouse on the SM-T585 and it pairs but gives no input.
---

TODO: CONFIG_UHID is not set in the pmOS kernel config (kernel/gtaxllte-pmos.config), so BLE HID keyboards/mice pair but deliver no input. Add CONFIG_UHID=m if the user's devices are BLE (ask the user which devices).
