# Standard-interfaces audit (non-audio), 2026-10-27

Scope: where SM-T585 kernel/DTS/pmOS work deviates from what generic userspace (upower, GNOME, logind, iio-sensor-proxy, NetworkManager, systemd) expects. Read-only audit of `src/mainline` (branch gtaxllte), `pmos/`, records. Nothing was built or run on the device; "needs HW" says whether the fix can only be proven on the tablet. Where I rely on how upower/GNOME behave, that is from memory of their source, not tested here: treat as "probable".

Legend: BUG = wrong or misleading behaviour for userspace; GAP = missing standard interface; STYLE = non-standard but harmless.

## Ranked findings

| # | Sev | Area | One-line |
|---|-----|------|----------|
| 1 | BUG | FG status | Battery STATUS from current sign only; disagrees with charger |
| 2 | GAP | thresholds/temp/health | On the charger (type USB) supply, not on the battery supply upower reads |
| 3 | GAP | FG props | No design/charge/energy props, no TEMP/CAPACITY_LEVEL: no time estimates, no health |
| 4 | GAP | notifications | No `power_supply_changed()` on the battery, no supplier link; cable events lag up to 5 s |
| 5 | BUG? | charger STATUS | TOPOFF bit mapped to FULL (probably early) |
| 6 | STYLE | policy default | 80/75 limit on by default via module params |
| 7 | STYLE/safety | `temp_offset` 0644 | Debug knob that can disable overheat protection |
| 8 | BUG (minor) | stmfts | `input_register_device()` before `pm_runtime_enable()` (-13) |
| 9 | CHECK | Home key | `KEY_HOMEPAGE` probably opens a browser in GNOME |
| 10 | CHECK | modules | Charger/FG are `=m`; charger sits at POR 4.34 V until loaded |
| 11 | STYLE | hardcoded FG name, no simple-battery | |
| 12 | GAP (large) | MUIC | No extcon: no OTG/host switching, no plug wakeup |
| 13 | STYLE | pmOS package | stray `initcall_blacklist` line in deviceinfo |

Fine as is: hall (SW_LID via gpio-keys), power key path, thermal/cpufreq, `chassis-type = "tablet"`, touch (`INPUT_PROP_DIRECT` via `INPUT_MT_DIRECT`).

---

### 1. Battery STATUS from the current sign (BUG)

- Non-standard: `sm5703_fg_get_status()` returns Charging if `current_now > 0`, else Discharging. It knows nothing about the charger. The charger says Charging / Not charging (limiter) / Full from its own registers.
- Is the "Discharging at 33 % on SDP while charger says Charging" a bug? Both readings can be physically true. On SDP the input limit is 450 mA (`sm5703_limits_sdp`). A running tablet with screen and WiFi can draw more than that, so the battery makes up the difference and net current is negative. The same happens whenever the limiter holds the charge FET off at 80 %: VBUS is present, nothing charges, net current is about zero or slightly negative. So the raw reading is a correct net-current reading, but the reported STATUS is wrong for the ABI. `Documentation/ABI/testing/sysfs-class-power` defines status as the charge state (Charging / Discharging / Not charging / Full), and charger-aware gauge drivers derive it from the supplier. Reporting Discharging with AC online is misleading.
- Userspace effect (probable): upower sees battery state `discharging` with line power online, so GNOME shows a draining battery and no charging icon, and low-percentage actions could fire while plugged in. In the limiter case ("Not charging" at 80 %) upower should show "pending-charge"; with the current code the battery says Discharging.
- Standard way: FG decides status like this, without writing anything: not supplied -> Discharging. Supplied -> take the supplier's STATUS (Charging / Full / Not charging); if the supplier is unreadable, fall back to the current sign with a deadband, and Not charging when plugged and net negative. Comparable: gauges with a charger partner use `power_supply_am_i_supplied()` plus the supplier's status (for example max17042, bq27xxx use AC presence plus current).
- Change: add `power-supplies = <&charger>` to the FG node (DT), and in the FG driver use `power_supply_am_i_supplied(psy)` (it returns 1 via the supplier's ONLINE) and `power_supply_get_property()` on the supplier. Needs the charger to be a registered supplier of the FG; see #4.
- Risk: low. HW test: yes (plug SDP with screen on at about 33 %: expect Charging or Not charging, never Discharging; unplug: Discharging; limiter at 80 %: Not charging).

### 2. Thresholds, TEMP and HEALTH sit on the charger supply (GAP)

- Non-standard: `charge_control_{start,end}_threshold`, `temp`, `health` live on `sm5703-charger` (type USB). Kernel convention is that these belong to the battery supply (thinkpad_acpi, asus-wmi, cros_charge-control all hang them on BATn; ABI says they are battery properties). The temperature is the battery NTC, so TEMP on a USB-type supply is also semantically off.
- Userspace effect (probable): upower reads charge thresholds and temperature from the battery device only. GNOME Settings > Power "Battery Health Charging" will not show for this device even though the kernel supports it, and upower will not report a battery temperature or health.
- Standard way: expose the same properties on the battery supply. The charger driver owns the state, the FG is the battery psy, so the FG forwards: for `CHARGE_CONTROL_*`, `TEMP`, `HEALTH` call `power_supply_get_property()` / `power_supply_set_property()` on its supplier. Alternative: register a second type-BATTERY psy from the charger driver (bigger change).
- Change: FG gets `property_is_writeable` and set/get forwarding to the charger psy found via the `power-supplies` link; keep charger props or drop them once userspace works.
- Risk: low-medium (two-way link, probe order: FG probes first and the charger registers later, so look the supplier up lazily). HW test: yes, check `upower -d` and the GNOME toggle.

### 3. Missing battery properties (GAP)

- Non-standard: FG provides only STATUS, PRESENT, TECHNOLOGY, VOLTAGE_NOW, VOLTAGE_OCV, CURRENT_NOW, CAPACITY. No `CHARGE_FULL(_DESIGN)`/`ENERGY_*`, `CHARGE_NOW`, `VOLTAGE_{MIN,MAX}_DESIGN`, `CAPACITY_LEVEL`, `TEMP`, `MODEL_NAME`.
- Userspace effect (probable): upower gets a percentage and a state, but no energy figures, so no time-to-empty/full, no battery-health figure (energy-full vs design); `CAPACITY_LEVEL` absent.
- Standard way: a `simple-battery` node (`Documentation/devicetree/bindings/power/supply/battery.yaml`) referenced by `monitored-battery` from FG (and charger), read with `power_supply_get_battery_info()` (how max17040, cw2015, rk817 do it). Gives `charge-full-design-microamp-hours`, `voltage-min/max-design-microvolt`, `constant-charge-voltage-max-microvolt`, `charge-term-current-microamp`. FG then reports `CHARGE_FULL_DESIGN`, `VOLTAGE_*_DESIGN`, `CHARGE_NOW = SOC * full / 100`, and `CAPACITY_LEVEL` derived from SOC (Critical <= 5, Low <= 15, Full when status Full, else Normal). Take values from the downstream DT/Lineage (I did not find them in the checked-out tree; the downstream submodule path had no hit for battery capacity strings, so locate them first rather than trusting the 7300 mAh spec-sheet figure). Do not report FG's own temperature register (record domain_t585_sm5703_fuel_gauge_readonly).
- Risk: low; DT + FG only, binding exists. HW test: partly (check sysfs values, then upower time estimates over a discharge).

### 4. Change notification and supplier links (GAP)

- Non-standard: the FG never calls `power_supply_changed()`; neither supply has `supplied_to`/`supplied_from`; the charger finds the FG by the hard-coded name `"sm5703-fuel-gauge"`. The charger polls every 5 s (cable, zones, limiter), and `online` is a cached value (`get_property` mixes cached `online` with a live STATUS3 read). No IRQ is used (MUIC gpa2-6 and charger gpa2-7 exist in DT), no resume hook (`mod_delayed_work` after resume), so state can be up to 5 s stale after resume. No wake on plug while suspended.
- Userspace effect: battery state/percentage uevents never fire, so upower/GNOME see changes only through upower's own timed refresh (order of tens of seconds, probable). Plug/unplug icon lags up to 5 s.
- Standard way: DT `power-supplies = <&charger>` on the FG node (core creates `supplied_from`; charger's `power_supply_changed()` then calls the FG's `.external_power_changed`, which calls `power_supply_changed(fg)`). FG also runs a slow delayed work (10-30 s) that calls `power_supply_changed()` when capacity or status changed. Charger: replace the name lookup with `power_supply_get_by_phandle()` / the same link; add the MUIC IRQ (read-only handler that schedules the poll work, optionally `wakeup-source`) while keeping the poll for zones.
- Risk: low (FG/work), medium for IRQ (MUIC irq is level-low on a chip we never write, mask/clear semantics unknown: could storm; do the FG part first). HW test: yes.

### 5. Charger STATUS maps TOPOFF to FULL (BUG, needs verifying)

- `sm5703_chg_get_status()`: `STATUS3_DONE | STATUS3_TOPOFF` -> Full. Top-off is the final taper phase (topoff timer 45 min configured in hw_init), so the battery is still being charged and SOC may be < 100. upower would show "fully charged" early. Check the vendor meaning (downstream sm5703_charger) before changing.
- Standard way: Full only on DONE, Charging during TOPOFF (as the common chargers do: bq24190 reports Full at charge termination only).
- Risk: low. HW test: yes (charge from ~95 %, read STATUS3 at top-off).

### 6. 80/75 limiter on by default (STYLE / policy)

- The kernel default for `charge_control_end_threshold` is 100 / no limit; policy normally comes from userspace (upower stores the GNOME setting in `/var/lib/upower` and re-applies it at start). Here `charge_end=80`, `charge_start=75` module params (0444) make the tablet stop at 80 % out of the box. Userspace effect: a plugged-in tablet that never reaches 100 % and shows "Not charging" (pending-charge). It is a deliberate user decision for longevity (record domain_t585_sm5703_charge_limiter_software_80_75), so only change it together with #2: default 100, and let GNOME's Battery Health Charging toggle (which sets 80/75 on the battery supply) or a udev rule own the limit. Risk low, HW test: yes.

### 7. `temp_offset` module parameter, mode 0644 (STYLE / safety)

- Root can shift the temperature the zones see at runtime, which can defeat the cold/hot cut-off. Module parameters are also not a stable ABI. Move behind debugfs or `#ifdef CONFIG_DEBUG_*`, or drop it now that the zones are verified (learning_t585_sm5703_charger_zones_verified_temp_offset). Userspace effect: none. Risk: none. HW test: no.

### 8. stmfts: input registered before runtime PM is enabled (BUG, minor)

- Probe order in `stmfts_probe()`: `stmfts_power_on` -> `input_register_device` -> LEDs -> `pm_runtime_enable`. `stmfts_input_open()` calls `pm_runtime_resume_and_get()`, which returns -EACCES while runtime PM is disabled. In-kernel handlers (the VT kbd handler is the one that fails with "error -13") open the device the moment it is registered. A userspace opener (libinput via udev) normally comes later, so GNOME is probably unaffected, but it is a real race (a failed open means no touch until the device is reopened). This is existing upstream code, not our FTS1A096 change.
- Standard way: enable runtime PM before registering input devices (as other input drivers do): `devm_pm_runtime_enable(dev)` (the chip is left in SLEEP_IN by `power_on`, which matches the default "suspended" runtime status, so no `pm_runtime_set_active` is needed), keep `device_enable_async_suspend()`, and drop the manual `pm_runtime_disable()` in `stmfts_remove`. Fits the "separate small fix" the todo describes; send upstream on its own.
- Risk: low. HW test: yes (dmesg without -13, touch after boot).
- The FTS1A096 variant itself is data-driven (`chip_info`, compatible `st,fts1a096`) and standard in shape. Swapped touch-key order (BACK/MENU vs MENU/BACK) is a per-chip keymap: fine.

### 9. Home key reported as KEY_HOMEPAGE (CHECK)

- `key-home` is `KEY_HOMEPAGE` (also the mainline convention for phone home keys). GNOME's gsd-media-keys maps XF86HomePage to "launch web browser" (probable). Standard fix is userspace, not kernel: a `/etc/udev/hwdb.d/` entry for the gpio-keys device remapping scancode -> `leftmeta` (opens the GNOME overview) or `homepage` kept; ship it in the device package. The touch keys (`KEY_BACK`/`KEY_MENU`) are harmless. Risk: none. HW test: yes (press Home in GNOME).

### 10. Charger and gauge are modules (CHECK)

- pmOS config has `CONFIG_BATTERY_SM5703=m` and `CONFIG_CHARGER_SM5703=m`. They autoload by of/i2c alias, but only once udev runs. Until then the charger is at its power-on state: the code comment says POR float is 4.34 V, above the 4.30 V the vendor kernel allows, and the 80 % limiter and temperature zones are not active. Also upower only sees a battery after the late load. Standard way for a charge-critical driver is built-in (`=y`), or listed for the initramfs (pmOS `deviceinfo_modules_initfs`). The rest of the repo already uses `gtaxllte-builtin.config` for such cases. Risk low; HW test: yes.

### 11. Hard-coded FG lookup, no `monitored-battery` (STYLE)

- Float voltage 4.30 V, top-off current, AICL threshold, swell limits are constants; standard is `monitored-battery` + `power_supply_get_battery_info()` (see #3). The temperature zone table stays vendor-specific (no mainline binding), which is acceptable. No userspace effect; matters for upstreaming.

### 12. No MUIC/extcon driver (GAP, large)

- The MUIC is only read (device-type registers); `EXTCON_SM5502` stays off because it would write the USB switch. So cable type comes from the charger driver, there is no extcon for USB role (OTG host mode, USB-C/microUSB host cables) and no wake on plug. Userspace effect today: none for normal charging/gadget use; OTG devices would not work. Standard way: an extcon/MUIC driver (`extcon-sm5502` family) plus a `usb_type`/`extcon` link in the charger. Out of scope for now; record as a todo.

### 13. pmOS device package (STYLE)

- `deviceinfo` contains `initcall_blacklist=efifb_driver_init` as a bare variable: it has no `deviceinfo_` prefix, so devicepkg ignores it; the real cmdline is in `kernel-cmdline.conf` (same string), so remove the stray deviceinfo line. `deviceinfo_chassis="tablet"` is right, and the DTS has `chassis-type = "tablet"` (hostnamed reads it). `deviceinfo_dtb` and `deviceinfo_drm` are standard. Nothing else non-standard found. Note: the blacklist exists because U-Boot's EFI GOP framebuffer would otherwise bind efifb next to simpledrm; keep it until a real panel driver replaces simpledrm.

---

## Checked and OK

- **Hall sensor**: separate gpio-keys node with `linux,input-type = <EV_SW>`, `linux,code = <SW_LID>`, `wakeup-source`. udev tags SW_LID devices `power-switch`, so logind watches it and GNOME handles lid close/open. Polarity (`GPIO_ACTIVE_LOW`) is unverified here: check `evtest` with a magnet; the lid action may suspend the tablet when a cover is closed, which is the standard tablet-cover behaviour.
- **Power key**: `KEY_POWER` via gpio-keys with `wakeup-source`. `pwrkeyd` is only built into the stage-1 initramfs (`kernel/build-stage1.sh`, started from `kernel/initramfs/init:78`). It is not referenced in `pmos/` (no package, no service) and the pmOS boot path is U-Boot -> systemd-boot -> pmOS initramfs (deviceinfo), which never contains it. So KEY_POWER reaches logind/gsd-power. Verify once on the device with `pgrep pwrkeyd` (should be empty); pwrkeyd would also grab the key if the old stage-1 image were still chained.
- **Thermal**: SoC zone polling 250 ms passive / 1000 ms, trips 81/91 passive, 115 critical, cpufreq cooling via `cooling-maps`; standard thermal-zone/cpufreq-cooling ABI, schedutil default, step-wise governor. The TMU extension is a normal `exynos_tmu` SoC variant. The one non-generic piece is the `cpufreq-dt` change (apply the boot OPP once, only if a regulator name is set): it alters shared code for all platforms, so it needs upstream-style justification, but it is invisible to userspace. The read-only CMU_CPUCL clocks mean the clock rate is changed through the existing CPU clock path (not audited further). The battery thermal zone (hot trip 50 C, no cooling map) is a plain generic-adc-thermal zone, harmless; it reads the ADC a second time every 5 s next to the charger poll (cosmetic).
- **Touch**: `INPUT_MT_DIRECT` sets `INPUT_PROP_DIRECT`, `touchscreen-size-*` parsed via `touchscreen_parse_properties`: libinput treats it as a touchscreen.
- **Sensors/BT**: out of this audit's scope (see `docs/sensors-test-plan-2026-10-27.md`, `docs/bluetooth-test-plan-2026-10-27.md`); the accelerometer mount-matrix is flagged "to be verified on hardware" in the DTS and matters for iio-sensor-proxy orientation.

## Suggested order of work

1. FG: `power-supplies` link + charger-aware STATUS + `external_power_changed` (#1, #4): one chunk, DT + FG, testable by plugging the cable.
2. FG: `simple-battery` props + threshold/TEMP/HEALTH forwarding (#3, #2, then #6 default).
3. Charger: TOPOFF/FULL check (#5), drop `temp_offset` (#7), built-in or initramfs (#10).
4. stmfts runtime PM order (#8) as a separate upstreamable patch; Home key hwdb (#9) and deviceinfo cleanup (#13) in the pmOS package.
5. Later: MUIC extcon (#12).

Record candidates: Decision: battery STATUS derives from the supplier, not the current sign. Why: ABI and upower semantics. Scope: sm5703_fuel_gauge.c.
