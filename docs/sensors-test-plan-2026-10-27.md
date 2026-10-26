# Sensors test plan (accelerometer, light sensor), 2026-10-27

Built, not yet run on hardware. DTS: `&i2c7` (MMIO 0x138d0000, downstream
"I2C_SENSOR1") with `accelerometer@1d` (`st,lis2hh12`, INT1 on gpa0-7, rising edge,
vdd = LDO33, vddio = LDO3) and `light-sensor@10` (`capella,cm3323`). LDO33 is now
always-on (the cm3323 driver takes no supply). Kernel: `st_accel`, `st_accel_i2c`,
`cm3323` as modules (`gtaxllte-pmos.config`); pmOS linux package pkgrel 4.

The vibrator is NOT part of this build, see the end.

## 1. Probe

```sh
dmesg | grep -i -E "i2c|lis2hh12|st_accel|cm3323|138d0000"
lsmod | grep -E "st_accel|cm3323|industrialio"     # if not auto-loaded:
sudo modprobe st_accel_i2c cm3323
ls /sys/bus/iio/devices/
for d in /sys/bus/iio/devices/iio:device*; do echo $d $(cat $d/name); done
```

Expected: two devices, `lis2hh12` and `cm3323`. The i2c bus is `138d0000.i2c`; find the
number with `ls -l /sys/class/i2c-dev/` if needed. Addresses 0x1d and 0x10.

Failure reading:
- Probe error -121/-110 (no ACK): bus or supply. `i2cdetect -y <n>` (or the repo `i2cx`
  tool). Check `cat /sys/class/regulator/*/name`, LDO33 state (`vdd_ldo33` must be enabled).
- WHO_AM_I mismatch (accel reads other than 0x41): wrong chip variant; `i2cget -y <n> 0x1d 0x0f`.
- No device but also no error: check the module loaded and `of_node` link in
  `/sys/bus/i2c/devices/<n>-001d/`.
- Before touching the DTS again, `echo lis2hh12 0x1d > /sys/bus/i2c/devices/i2c-<n>/new_device`
  binds the driver without the node (no IRQ, polling only).

## 2. Raw reads

```sh
A=/sys/bus/iio/devices/iio:device0     # the lis2hh12 one, check name
cat $A/in_accel_{x,y,z}_raw $A/in_accel_scale $A/in_accel_mount_matrix
cat $A/sampling_frequency $A/sampling_frequency_available
L=/sys/bus/iio/devices/iio:device1     # cm3323
cat $L/in_intensity_{red,green,blue,clear}_raw $L/integration_time
```

`in_accel_*_raw` are in the CHIP frame; the mount matrix is applied only by consumers
(iio-sensor-proxy, hwdb), never to raw. With the current matrix `diag(1, 1, -1)` the
expected raw readings (1 g = about 16400 counts at 2 g, times scale 0.000598 m/s2 per count
= 9.8) are: flat on a table, screen up: z about -1 g, x and y near 0 (chip z points into
the screen, per the downstream negate_z). Section 4 explains how to judge them.
Cover the light sensor with a hand: `in_intensity_clear_raw`
falls; point at a lamp: it rises. Note: the cm3323 driver has no illuminance channel and no
scale attribute, so GNOME gets raw clear counts (iio-sensor-proxy falls back to scale 1.0),
lux values are relative, not calibrated.

Buffered path (the INT1 interrupt): `cat /proc/interrupts | grep -i lis2hh12` (or the
gpa0-7 line), then
```sh
echo 1 > $A/scan_elements/in_accel_x_en   # and y, z, timestamp
echo lis2hh12-trigger > $A/trigger/current_trigger   # name from `cat /sys/bus/iio/devices/trigger*/name`
echo 32 > $A/buffer/length; echo 1 > $A/buffer/enable
```
If the counter in /proc/interrupts does not rise while tilting, the INT1 pin or its
edge is wrong; remove `interrupts`/`pinctrl` from the node, the driver then polls via
sysfs and iio-sensor-proxy still works with the poll path.

## 3. Orientation in GNOME

```sh
systemctl status iio-sensor-proxy
monitor-sensor
```
Initial line: `Has accelerometer (orientation: normal)` and `Has ambient light sensor (value: N, unit: ...)`.
With GNOME auto-rotate on (Quick Settings), expected for each pose (tablet held facing you,
panel is portrait-native, natural orientation = home button / USB at the bottom of the
portrait panel; check against the device's actual portrait):

| Pose | Expected `monitor-sensor` |
|---|---|
| portrait, top up | `normal` |
| portrait, upside down | `bottom-up` |
| landscape, rotated so the former top of the panel points left | `left-up` |
| landscape, former top points right | `right-up` |
| flat on table | no change (last orientation kept) |

Orientation names refer to which edge of the NATURAL (portrait) panel faces up: left-up =
the left edge of the portrait panel is up.

## 4. If the rotation is wrong (mount-matrix fix)

The matrix maps sensor axes to the frame x = right, y = up (screen top), z = out of the
screen, in the panel's native portrait orientation. Current value `diag(1, 1, -1)` comes
from the downstream k2hh (axis map 0,1,2, negate z only). A pure z flip is a mirror, which a
rigidly mounted chip cannot be, so this value is the most likely thing to be wrong: the
downstream Samsung sensor HAL may have flipped a second axis.

Find the truth with the raw numbers. Expected frame values (x right, y up, z out of the
screen) are what the matrix must produce; raw = inverse matrix applied to those. For the
current matrix, raw x and y equal the frame values, raw z has the opposite sign:
- Portrait, top up, screen facing you: raw y about +1 g. If -1 g, y must be negated.
- Portrait, right edge pointing up (rotate the tablet 90 degrees): raw x about +1 g. If -1 g,
  x must be negated. Left edge up: x about -1 g.
- Flat, screen up: raw z about -1 g with the current matrix. If it reads +1 g instead, the
  chip z already points out of the screen and the z entry must be +1.
Change a matrix row only where the observed raw sign differs from this prediction.

Per-axis candidates (rows are the output x, y, z in terms of the chip axes):
- x and y swapped: `"0","1","0", "1","0","0", "0","0","1"` (check the sign of each row too).
- 180 degrees about z: `"-1","0","0", "0","-1","0", "0","0","1"`.
- 90 degrees: `"0","-1","0", "1","0","0", "0","0","1"` or its negation.

Quick test without rebuilding the kernel: a udev hwdb override read by iio-sensor-proxy
(`ACCEL_MOUNT_MATRIX`), in `/etc/udev/hwdb.d/61-sensor-local.hwdb`:
```
sensor:modalias:i2c:lis2hh12*   (use the modalias shown by udevadm info -a -p /sys/bus/iio/devices/iio:device0)
 ACCEL_MOUNT_MATRIX=1, 0, 0; 0, 1, 0; 0, 0, -1
```
then `sudo systemd-hwdb update && sudo udevadm trigger -s iio`, restart `iio-sensor-proxy`.
The hwdb value wins over the kernel matrix. Once right, copy it into the DTS
`mount-matrix` and drop the hwdb file.

## 5. Light sensor in GNOME

`monitor-sensor` prints the light level changing when covering the sensor. Automatic
brightness will track it but with uncalibrated counts; adjust only if it behaves badly.

## 6. Vibrator (not done)

The downstream `sec_vib` switches the SM5703 LDO2 (`VDD_MOTOR_3.3`, register LDOOUT2CNTL,
enable bit 3) on the SM5703 MFD at i2c4 @0x49. Mainline has no SM5703 regulator driver, and
the address is already taken by our charger driver, so `regulator-haptic` has no regulator
to point at. Options for later: expose LDO2 as a regulator from the sm5703 charger driver
(regmap, one fixed 3.3 V `regulator_desc` with enable_reg/mask), then add a
`regulator-haptic` node (`haptic-supply`, `min/max-microvolt = <3300000>`) and
`CONFIG_INPUT_REGULATOR_HAPTIC=m`. Test would be `fftest /dev/input/eventN` (FF_RUMBLE) or a
tiny evdev write with `EVIOCSFF`.
