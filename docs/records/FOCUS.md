Project: lean-Linux revival of the Samsung SM-T585 (gtaxllte, Exynos 7870, 2 GB RAM) as a music device (first target: USB-MIDI pad controller). Records: domain_t585_lean_linux_music_device_2026_10_23, domain_target_device_sm_t585_2026_10_23.
STATE: mainline 7.3 stage 1 (busybox initramfs) on our fork src/mainline (branch gtaxllte). Working on HW: CPUs + cpufreq/DVFS + TMU thermal with cooling maps, eMMC, PMIC regulators, keys/hall, touch, simpledrm console, USB gadget shells, audio (RT5659: playback, capture, jack), SM5703 fuel gauge + charger (cable type via MUIC reads, 80/75 % limiter, battery-NTC temperature zones via the new Exynos7870 ADC). BOOT holds kernel #30 (sha1 a011733c640c477dac02d1a6ebdac42f1a9438bd); fallbacks kernel/out/boot-stage1-k28/k29.img. Details: docs/handoff-2026-10-24.md.
NEXT (user order, 2026-10-24):
1. Fix the warnings (dtbs_check list + ADC dummy vdd regulator, see handoff).
2. Open charger review findings (teardown race, stale TEMP on NTC read failure).
3. Test the COOL/WARM/HOT charger zones on HW (lowered thresholds).
4. Power button with a standard behaviour (e.g. as in systemd-logind / Android): short press = display off, long press = power off.
5. Panfrost (Mali-T830 GPU).
6. Bluetooth.
Then evaluate: can our mainline kernel run the installed LineageOS userspace? Otherwise postmarketOS.
Workflow: bring-up stays interactive; flashing BOOT is run by the user via "!" (auto mode blocks dd), image staged in /tmp first. Self-contained driver code can go to a Sonnet the-coder with a tight brief; HW test and review stay with the orchestrator.
Record candidates go to the archivist immediately (domain_archivist_candidates_sent_immediately_2026_10_23).
