id: learning_t585_uart_via_usb_jig_2026_10_23
type: learning
area: device
perspective: agent
created: 1792769194.309014
edges: [{"target_id": "domain_target_device_sm_t585_2026_10_23", "edge_type": "related"}]
cue: You need a serial console on the SM-T585 and consider opening it up or soldering to mainboard pads.
---

Observed: SM-T585 UART access should work without disassembly via a microUSB jig: the SM5703 MUIC (downstream drivers/muic/sm5703-muic.c) handles JIG_UART_OFF/ON. Standard Samsung ID resistor values: 619 kOhm (UART, boot off) / 523 kOhm (UART on); use a 1.8V-capable USB-UART adapter, 115200 8N1. The ~150 kOhm in the old FOCUS.md is likely wrong. NOT verified on hardware. Mainline has no SM5703 MUIC driver, so it is open whether the UART path survives the kernel handover. Mainboard pads (needs disassembly) are the last resort. A failed boot test does not brick the device: only the BOOT partition is written; Download mode (Vol-down+Home+Power) and TWRP (Vol-up+Home+Power) stay reachable; a backup of the Lineage boot.img is on the device at /sdcard/boot-lineage.img.
Cause: n/a (derived from downstream source and Samsung conventions).
Evidence: src/downstream-lineage-21 drivers/muic/sm5703-muic.c; session 2026-10-23.
