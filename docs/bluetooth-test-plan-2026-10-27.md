# Bluetooth test plan (QCA9377 BT, UART HCI), 2026-10-27

Status: built only, never run on hardware. linux pkgrel 5, device pkgver 5.

## What was built

- DTS: `&serial1` (uart@13810000, downstream `serial_0`, UART_BTWIFIFM, pins gpb0-0..3 =
  RXD/TXD/CTS/RTS via `uart1_bus`) with `uart-has-rtscts` and a child
  `bluetooth { compatible = "qcom,qca9377-bt"; }`.
- BT_EN = gpd4-0 (`enable-gpios`, pinctrl `bt_en`: output, pull-down). 32.768 kHz sleep clock
  = fixed-clock `bt_sleep_clk` (binding requires a clock; presumably the PMIC 32 kHz output,
  unverified).
- Kernel (modules): `bluetooth`, `hci_uart` (H4 + QCA, serdev), `btqca`, `rfcomm`, `bnep`,
  `hidp`; `BT_LE=y`. Other vendors' HCI drivers and `btusb` are off.
- Packages: `linux-firmware-qca`, `bluez` added to `device-samsung-gtaxllte`.
- Not wired (no binding/driver support): BT_WAKE gpa1-2, BT_HOST_WAKE gpa1-6. hci_qca uses
  in-band sleep (IBS), so they should not be needed.
- Default speed: init 115200, operating 3000000 baud (hci_qca ROME default).

## WiFi and BT share cnss_dcdc_en

`vdd_fixed_wlan` (regulator-name `cnss_dcdc_en`, gpa0-6) powers the whole QCA9377 chip. mmc1
holds it as `vmmc-supply`; the BT node lists it as `vddio-supply` only for device-link
ordering and documentation: hci_qca does not manage supplies for the ROME (qca6174/qca9377)
path. Consequences:

- BT works only while that regulator is on. Check `cat /sys/class/regulator/*/name` and the
  matching `state` for `cnss_dcdc_en`. If mmc1 fails to enumerate the SDIO card, mmc core
  powers the regulator off again and BT then cannot talk.
- Unloading/rebinding the WiFi side while BT is up can cut BT power.

## 1. Before the test

Firmware: the kernel asks for `qca/rampatch_<soc_ver>.bin` and `qca/nvm_<soc_ver>.bin`
(`soc_ver` read from the chip, printed as `QCA controller version 0x........`).
`linux-firmware-qca` ships `rampatch_00130302.bin`, `rampatch_00440302.bin`, `nvm_00130302.bin`,
`nvm_00440302.bin` (zstd-compressed, kernel has FW_LOADER_COMPRESS_ZSTD) and more. If the
version printed by the kernel is one of those, nothing else is needed.

Fallback only if the log says `Failed to request file: qca/rampatch_XXXXXXXX.bin`: the
downstream files are the same TLV format (`rampatch_tlv_tf_1.1.tlv`, `nvm_tlv_tf_1.1.bin`;
rom_build 0x0302). On the device, as root, with the repo copy on the host:

```sh
# host
scp device-dump/sm-t585/firmware/firmware/{rampatch_tlv_tf_1.1.tlv,nvm_tlv_tf_1.1.bin} user@tab:/tmp/
# device
sudo mkdir -p /usr/lib/firmware/qca
sudo cp /tmp/rampatch_tlv_tf_1.1.tlv /tmp/nvm_tlv_tf_1.1.bin /usr/lib/firmware/qca/
```

and give the names in the DTS node (nothing in git ships the blobs):
`firmware-name = "nvm_tlv_tf_1.1.bin", "rampatch_tlv_tf_1.1.tlv";` (order: nvm, rampatch).
Alternative without a DTS change: `sudo cp` them as the exact `rampatch_<soc_ver>.bin` /
`nvm_<soc_ver>.bin` names from the log.

## 2. Boot checks

```sh
dmesg | grep -i -E 'bluetooth|hci|qca|serial1|13810000|btqca'
```

Expect, in order:
1. `13810000.serial: ... is a S3C6400/10` (serial1 registered). Debug console stays serial2.
2. No `failed to acquire` for enable gpio / clk, no probe deferral loop
   (`cat /sys/kernel/debug/devices_deferred`).
3. `Bluetooth: hci0: QCA controller version 0x........` - note this value.
4. `hci0: QCA Downloading qca/rampatch_...` then `QCA Downloading qca/nvm_...` and
   `QCA setup on UART is completed`.

```sh
lsmod | grep -E 'hci_uart|btqca|bluetooth'
hciconfig -a        # or: btmgmt info
rfkill list
```

## 3. BlueZ

```sh
systemctl status bluetooth      # enabled by bluez-systemd on pmOS systemd
bluetoothctl
  power on
  scan on               # a phone/headset in pairing mode should show up
  devices
```

Pair a keyboard/controller (`pair`, `trust`, `connect`) for the later ExoDeck HID use.
Dongle-independent check: `btmon` in a second terminal while running `power on`.

## 4. If it does not work

| Symptom | Likely cause / next step |
|---|---|
| No `hci0`, no BT messages | serdev did not bind: check `ls /sys/bus/serial/devices/`, `cnss_dcdc_en` state, `modprobe hci_uart` |
| `Failed to request file` | firmware name, see section 1 |
| `Reading QCA version information failed (-110)` / timeouts | wrong UART/pins, no flow control, BT_EN or power: probe `/sys/kernel/debug/gpio`, check `cnss_dcdc_en` is on |
| Fails only after the speed switch (115200 -> 3000000) | add `max-speed = <921600>;` (or 1500000) to the bluetooth node |
| Works for a while then stalls | sleep clock not really running, or IBS needs BT_WAKE/HOST_WAKE: keep dmesg, then consider wiring gpa1-2/gpa1-6 |
| `hci0` fine but no scan results | rfkill soft block (`rfkill unblock bluetooth`), antenna shared with WiFi |

## 5. Open questions to settle on hardware

- Real source of the 32 kHz clock (fixed-clock node is an assumption).
- soc_ver actually read, and whether `linux-firmware-qca` covers it.
- Whether 3 Mbaud works with the Exynos UART clock.
