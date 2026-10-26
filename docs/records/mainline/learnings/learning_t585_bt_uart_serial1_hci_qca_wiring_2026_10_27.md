id: learning_t585_bt_uart_serial1_hci_qca_wiring_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793002789.716219
edges: [{"target_id": "todo_bluetooth_then_dsi_panel_2026_10_23", "edge_type": "related"}]
cue: You wire the T585 Bluetooth UART in the board DTS and the downstream serial_0 does not match the mainline serialN number.
---

Observed: Downstream serial_0 (uart@13810000) is mainline &serial1, because mainline numbers the UARTs from 13800000. The BT UART uses the uart1_bus pins gpb0-0..3 including RTS/CTS (uart-has-rtscts). The debug console serial2 is untouched.
Cause: mainline and downstream UART numbering differ by one base address.
Evidence: board DTS exynos7870-gtaxllte.dts BT chunk, 2026-10-27; build and dtbs_check clean, untested on HW.
