# SM-T585 — s2idle resume: debug plan

## Charter
- Scope: system suspend/resume on pmOS (r9 kernel), so that closing the cover (logind
  `HandleLidSwitch=suspend`) and later `HandlePowerKey=suspend` on the console are safe.
- Terms: *suspend* = s2idle (`/sys/power/mem_sleep` offers only `[s2idle]`, no `deep`; no cpuidle
  states, so CPUs only WFI); *comes back* = ssh answers with the same boot id after the wake.
- Mode: one variable per run, prediction written before each run. Root on the tablet: see
  CLAUDE.local.md. Live `dmesg -w` over ssh during every run (hangs are only visible there; pstore
  is overwritten on the next boot and systemd-pstore keeps only the last one).
- Out of scope: `deep` suspend (needs firmware PSCI SYSTEM_SUSPEND or downstream exynos-pm SMC
  code), cpuidle states (separate todo if battery life becomes a goal).

## Facts (2026-10-29)
- Trigger of all suspends so far: the cover (logind "Lid closed.", 30 s holdoff at boot).
- A 5 s suspend came back (hall wake, display after a few seconds, WiFi reconnected).
- The overnight suspend (23:38 → morning) did not come back: next boot is a fresh one. Battery is
  not the cause (upower history 91 % → 88 % across the night and the following day).
- Known bug: `sm5703_chg_poll` and `sm5703_fg_poll` run every 5 s on `system_wq`, which is not
  frozen. During suspend they hit suspended I2C adapters ("Transfer while suspended" WARN), the
  battery ADC read times out and the charger falls back to zone HOT and disables charging.
- Wake sources: gpio-keys power/home (gpa0-0, gpa1-7), hall (gpa1-3), PMIC RTC alarm
  (`rtcwake`), all `wakeup-source`. pinctrl warns "no retention data … wake-up mask will not be
  set" — that PMU mask matters only for a PMU sleep state, not for s2idle (hall wake worked).
- No watchdog device; systemd RebootWatchdog only applies at reboot.

## Hypotheses for "overnight did not come back"
- **H1 – poll during suspend:** repeated I2C/ADC access from the unfrozen poll work wedges a bus
  or the ADC over minutes/hours, so the system hangs in suspend or in resume.
  Predict: without the fix, a 10 min `rtcwake` run shows ~120 WARNs and may not come back; with
  the fix, zero WARNs and it comes back.
- **H2 – wake source:** after a long suspend the power key (or the cover) does not wake the
  system; RTC and hall did in short runs.
  Predict: H2 → `rtcwake` 1 h comes back, a power-key wake after 10 min does not.
- **H3 – driver resume after a long suspend:** a device (ath10k SDIO, DSIM/panel, stmfts, USB
  gadget) fails to resume after a long sleep (e.g. its supply or link dropped).
  Predict: H3 → the kernel resumes (dmesg -w shows "PM: suspend exit") but a driver errors or
  hangs; ssh may come back while the screen stays black.

## Order
0. Baseline without changes, short: `rtcwake -m freeze -s 20` twice. Record WARN count, the
   time from wake to "PM: suspend exit", and to the first frame (user looks, or dpms).
1. Fix the known bug (one variable): queue both poll works on `system_freezable_wq`
   (frozen before device suspend, thawed after resume; the threshold write path uses
   `mod_delayed_work` on the same queue). Alternative if that is not enough: `dev_pm_ops`
   suspend = `cancel_delayed_work_sync`, resume = requeue at 0. Test modules first
   (charger and FG are modules), then 20 s runs: predict zero WARNs, no HOT zone.
2. Ladder with the fix, RTC wake: 20 s → 2 min → 10 min → 1 h. Each run: comes back? WARN/error
   lines, suspend exit, WiFi, display, battery % before/after. Stop at the first failure and
   read the live dmesg.
3. Wake sources after 10 min: power key, then cover (user present). Separates H2.
4. Cover run of 1–2 min with the user (close, wait, open), ssh + dmesg right after.

Acceptance: 1 h RTC run and one overnight cover run come back, zero suspend-time WARNs,
display and WiFi back, charger zone stays correct. Then HandlePowerKey=suspend can be offered
for the console (domain_t585_no_custom_power_key_console_handling_2026_10_29).

Safety: `systemd-inhibit` is not needed for rtcwake runs; between runs the cover stays off. A
hang needs the user's Power+Vol-down reset, so ladder steps from 10 min on run only while the
user is around.

## Result (2026-10-29)
- Baseline (r9): every s2idle run came back, but the charger fell to zone HOT each time (poll
  work during suspend).
- Fix src/mainline 479f8fe10 (poll works on system_freezable_power_efficient_wq), packaged as
  linux-samsung-gtaxllte r10: RTC runs 20 s, 2 min, 10 min, cover wakes (74 s, 13 s), power-key
  wake with the cover closed — all came back, no I2C warnings, zone stays normal, WiFi and
  display back. H1 fixed, H2 excluded; 1 h / overnight left to everyday use.
- Side findings: stmfts logs "error code 0x0dec00d0ba" once per resume (harmless so far); after
  suspends longer than 3 min systemd restarts journald/udevd on watchdog timeout — the kernel
  clock keeps running through s2idle (no cpuidle driver), so frozen services look hung.
