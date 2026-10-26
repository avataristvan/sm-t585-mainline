# DSI panel test plan (prepared 2026-10-26, untested on hardware)

What changed: `&decon` + `&dsi` enabled, new panel driver `panel-samsung-gtaxllte-hx8279d`
(module, compatible `samsung,gtaxllte-boe-hx8279d`), backlight `/sys/class/backlight/<dsi device name>`
via DSI register 0xB8. DRM_EXYNOS/DECON/DSIM stay built-in, `BACKLIGHT_CLASS_DEVICE=y`.
simple-framebuffer stays, so the bootloader framebuffer / simpledrm still shows a console if
the panel driver does not come up. LCD_1P8 (ldo35) and the new buck (`vdd_fixed_lcd`, gpd3-4)
are always-on, so nothing cuts the panel power.

## Build / install
Kernel build is done (`kernel/build`), `pmos/linux-samsung-gtaxllte` is at pkgrel 3 with the new
config. Build the package and install as usual; check `/lib/modules/*/kernel/drivers/gpu/drm/panel/panel-samsung-gtaxllte-hx8279d.ko*` exists.

## 1. First boot, nothing loaded yet
    dmesg | grep -iE "exynos|decon|dsim|dsi|drm"
Expect decon/dsi probe; the DSI bind waits for the panel (no `card1` yet) or logs a deferral.
simpledrm console still works. If the kernel panics/hangs here, the problem is DECON/DSIM
(built-in): boot the old package (pkgrel 2) from the ESP.

## 2. Load the panel
    sudo modprobe panel-samsung-gtaxllte-hx8279d
    dmesg | tail -50
    ls /dev/dri /sys/class/drm /sys/class/backlight
Expect: `Attached ... device (lanes:4 ...)` from the DSIM, a second DRM card (exynos), connector
`DSI-1` with mode 1200x1920, `/sys/class/backlight/<dsi device name>`.
Things to look for in dmesg:
- `failed to get ... supply` / reset gpio: DT wiring (vdd_ldo35, vdd_fixed_lcd, gpd4-1).
- DSI transfer timeouts / `-EINVAL` in prepare: command path (host not up when the panel prepares;
  the driver sets `prepare_prev_first`).
- FIFO underrun / `lcd_sys` IRQ messages: timing/clock (burst clock 980 MHz, pixel clock 159.6 MHz).
- Image appears but is shifted/torn: porches (hbp 32 hfp 120 hsa 8 / vbp 16 vfp 16 vsa 4 from downstream).
- Image dark but present: check `cat $BL/brightness` (default 117 of 255).
- Everything is DT/driver guesswork on: NO_EOT_PACKET (downstream writes panel reg 0xB1=0xE5),
  burst + HSE + NO_HFP flags (from downstream dsim register setup).

## 3. Fallback if the screen goes black or the system hangs
ssh over USB-NCM/WiFi still works. To stop the panel driver from loading:
- running system: `sudo rmmod panel-samsung-gtaxllte-hx8279d` — remove now disables/unprepares the
  panel (DSI sleep + reset asserted), so the screen stays dark afterwards; reboot (with the blacklist below) to get the
  simpledrm console back.
- persistent: `echo "blacklist panel_samsung_gtaxllte_hx8279d" | sudo tee /etc/modprobe.d/no-gtaxl-panel.conf`
- one boot, no file change: add `module_blacklist=panel_samsung_gtaxllte_hx8279d` to the kernel cmdline in the systemd-boot entry.
If DECON/DSIM itself breaks boot: `initcall_blacklist=` is not enough; boot the previous kernel entry (pkgrel 2).
Pstore (ramoops) still captures panics.

## 4. Blanking and brightness
    BL=$(ls -d /sys/class/backlight/*)
    echo 0   | sudo tee $BL/brightness     # dark (panel on, BL register 0)
    echo 255 | sudo tee $BL/brightness     # full (hardware value 199)
    echo 1   | sudo tee $BL/bl_power        # blank
    echo 0   | sudo tee $BL/bl_power        # unblank
DPMS off/on (panel unprepare/prepare, includes the reset + 257-write init):
    modetest -M exynos -a -w <connector>:DPMS:3  (or via GNOME: Super+L / power button)
GNOME Mobile: brightness slider should move `brightness`; screen blank should switch the connector off.
Watch dmesg while blanking: the init after unblank is the riskiest part (reset sequence, `msleep` timing).

## 5. Which card does GNOME use?
simpledrm (card0) and exynos (card1) are both present. If mutter keeps using simpledrm (no DPMS,
no backlight), point it at card1: `MUTTER_DEBUG_KMS_THREAD_TYPE`-style tricks are unreliable, the
robust way is udev tag `mutter-device-preferred-primary` on card1, or (test only) `fbcon=map:1`.
Removing the `simple-framebuffer` node from the DTS is the last resort once the DSI path works.

## Report back
dmesg after step 2 (full), `ls /dev/dri`, `modetest -M exynos` output, whether anything is visible
(and its geometry/color), and the result of step 4.

## Step 2: switchable panel power (prepared 2026-10-26, untested on hardware)

Do this only after steps 1-4 work with the default DTB. The panel driver now powers on in the
downstream order (iovcc/LCD_1P8, 10 ms, vdd/gpd3-4, 15 ms, reset high-low-high 10 ms each) and off
as reset asserted, vdd off, 10 ms, iovcc off. With the default DTB both supplies are
`regulator-always-on`, so the refcount never reaches 0 and blanking is only DSI sleep + reset.
The variant DTB removes `regulator-always-on` from `vdd_fixed_lcd` and from `ldo35` (LCD_1P8;
in our DTS it feeds only the panel, touch uses `vdd_fixed_tsp_a/d`). It keeps `regulator-boot-on`:
that makes the fixed regulator's GPIO come up high at probe and leaves LDO35 as the bootloader
set it, so the simpledrm console stays lit until the panel module loads. Caveat: the regulator
core's late cleanup (30 s after init) switches off boot-on rails without a consumer, so if
`panel-samsung-gtaxllte-hx8279d` is not loaded by then, the screen goes dark (ssh still works);
that is expected, not a bug. It also means: with the variant, blanking really cuts power and
the panel is re-initialised (full init sequence) on every unblank.

### Build the variant DTB (host)
    kernel/tools/mk-panelpwr-dtb.sh        # -> kernel/out/exynos7870-gtaxllte-panelpwr.dtb
Rerun after every kernel/DTB rebuild. Rebuild and install the module package too (the driver
changed: `pmos/linux-samsung-gtaxllte` pkgrel bump) so the default entry also uses the new driver.

### Add a second systemd-boot entry (device, via ssh)
Boot chain: U-Boot -> `bootefi bootmgr` -> systemd-boot on the FAT32 `/boot` (ESP) -> entry
`/boot/loader/entries/pmos.conf` (written by boot-deploy; its `devicetree exynos7870-gtaxllte.dtb`
line is relative to the ESP root, i.e. `/boot/exynos7870-gtaxllte.dtb`). boot-deploy only rewrites
`pmos.conf` and the dtb, extra entries and files are left alone. Check on the device first:
    cat /boot/loader/entries/pmos.conf; ls /boot /boot/loader
From the host:
    scp kernel/out/exynos7870-gtaxllte-panelpwr.dtb user@<device>:/tmp/
On the device:
    sudo cp /tmp/exynos7870-gtaxllte-panelpwr.dtb /boot/exynos7870-gtaxllte-panelpwr.dtb
    sudo sed -e 's/^title .*/title postmarketOS (panel power cut)/' \
             -e 's/^sort-key .*/sort-key zz-panelpwr/' \
             -e 's|^devicetree .*|devicetree exynos7870-gtaxllte-panelpwr.dtb|' \
             /boot/loader/entries/pmos.conf | sudo tee /boot/loader/entries/pmos-panelpwr.conf
    diff /boot/loader/entries/pmos.conf /boot/loader/entries/pmos-panelpwr.conf   # 2-3 lines differ (sort-key only if pmos.conf has one)
    sync
Only the `linux`/`initrd` lines are shared with the default entry, so a kernel update stays in step.
The new entry sorts after `pmos`, so `pmos` stays the default.

### Selecting the entry
There is no keyboard in systemd-boot, so select through `/boot/loader/loader.conf`
(no file exists by default):
    echo "default pmos-panelpwr.conf" | sudo tee /boot/loader/loader.conf; sync; sudo reboot
Back to normal: `sudo rm /boot/loader/loader.conf; sync; sudo reboot`. Check which one booted:
    cat /proc/cmdline; fdtget /sys/firmware/fdt /regulator-fixed-lcd regulator-always-on  # error = variant
(`fdtget` reads the live DT; or `ls /proc/device-tree/regulator-fixed-lcd/`: no `regulator-always-on` file in the variant.)
No boot counting: without systemd-bless-boot nothing marks a boot good, so a `+N` entry name would just expire.

### Fallback
The default entry `pmos.conf` and `/boot/exynos7870-gtaxllte.dtb` are never touched. If the screen
stays dark or the system misbehaves: ssh in (USB-NCM), `sudo rm /boot/loader/loader.conf; sync; sudo reboot`.
If ssh is also gone, loader.conf stays in effect on every boot; there is no verified way to edit
the ESP without the running system (the userdata image sits behind U-Boot's blkmap), so do the test only while an ssh session is easy to get back.
The variant only changes regulator properties, so a hang at boot is unlikely; a dark screen is the realistic failure.

### What to check (variant DTB)
    sudo modprobe panel-samsung-gtaxllte-hx8279d      # if udev has not loaded it already
    cat /sys/kernel/debug/regulator/regulator_summary | grep -E "vdd_ldo35|vdd_fixed_lcd"   # use_count 1 while lit
    dmesg | grep -iE "regulator|vdd_ldo35|vdd_fixed_lcd|hx8279|gtaxl|dsim"                  # no errors/WARN
- Panel lit after module load (first prepare, powered up from the bootloader state, reset sequence).
- Blank (`modetest -M exynos -a -w <connector>:DPMS:3`, or GNOME screen blank / Super+L): the panel goes
  fully off (no backlight glow, no residual image), `regulator_summary` shows use_count 0 and the
  rails off (`vdd_fixed_lcd` / `vdd_ldo35` disabled).
- Unblank (`DPMS:0`, mouse/touch/power key): image returns, correct colours/geometry, no `-ETIMEDOUT`
  or FIFO underrun in dmesg. Repeat blank/unblank 10 times.
- `sudo rmmod panel-samsung-gtaxllte-hx8279d; sudo modprobe ...` again: no regulator refcount warnings.
- Not-ok signs: image absent after unblank (init order/timing), `regulator ... unbalanced disables`, white/flicker after unblank.

### Measure the effect (no extra hardware)
Fuel gauge: SM5703, `/sys/class/power_supply/*` (find the gauge with `grep -l . /sys/class/power_supply/*/current_now`).
Unplug USB charging for the run (use WiFi ssh; on USB-NCM the host charges the tablet and the
sign/value of `current_now` is meaningless) and keep CPU idle, brightness fixed, e.g. `echo 255 > $BL/brightness`.
Three states: screen on (any DTB), DSI-sleep blank (default DTB entry), power-cut blank (variant entry).
Same loop each time, run after the state has settled for ~20 s:
    G=$(dirname $(ls /sys/class/power_supply/*/current_now | head -1))
    for i in $(seq 1 15); do
      echo "$(date +%T) $(cat $G/current_now) uA $(cat $G/voltage_now) uV"
      sleep 2
    done | tee /tmp/cur-<state>.txt
    awk '{s+=$2; n++} END {print "mean current_now:", s/n, "uA over", n, "samples"}' /tmp/cur-<state>.txt
The difference between the DSI-sleep and power-cut means is the saving of the panel supplies
(expect a small value; compare against sample spread, so take at least 15 samples per state and
repeat a state if the spread exceeds the difference). Report the three means plus the spread.
