Project: lean-Linux revival of the Samsung SM-T585 (gtaxllte, Exynos 7870, 2 GB RAM) as a music device (first target: USB-MIDI pad controller). Records: domain_t585_lean_linux_music_device_2026_10_23, domain_target_device_sm_t585_2026_10_23.
STATE: mainline 7.3 stage 1 (busybox initramfs) on our fork src/mainline (branch gtaxllte). Working on HW: CPUs + cpufreq/DVFS + TMU thermal with cooling maps, eMMC, PMIC regulators, keys/hall, touch, simpledrm console, USB gadget shells, audio (RT5659: playback, capture, jack), SM5703 fuel gauge + charger (cable type via MUIC reads, 80/75 % limiter, battery-NTC temperature zones via the new Exynos7870 ADC). BOOT holds kernel #31 (sha1 2394b2a5fa4e7c686c398e6b65ded5386fde96aa, kernel/out/boot-stage1-k31.img); fallback kernel/out/boot-stage1-k29.img. Details: docs/handoff-2026-10-24.md.
NEXT (user order, 2026-10-24; items 1-4 of the earlier list are done):
1. PMIC reset test: stop pwrkeyd, hold only Power ~15 s. Reboot = 1-key manual reset; none = 2-key (S2MPU05 CTRL1=0x14 MRSTB_EN=1, CTRL3=0x04 MRSEL=0 suggests 2-key).
2. build-stage1.sh keeps a numbered copy boot-stage1-k<N>.img automatically.
3. Rebuild and flash so BOOT matches the commits (#31 on BOOT still has the charger `stopping`-flag variant; committed is disable_delayed_work_sync, verified only by module swap).
4. Panfrost (Mali-T830 GPU).
5. Bluetooth.
Then evaluate: can our mainline kernel run the installed LineageOS userspace? Otherwise postmarketOS.
Workflow: bring-up stays interactive; flashing BOOT is run by the user via "!" (auto mode blocks dd), image staged in /tmp first. Self-contained driver code can go to a Sonnet the-coder with a tight brief; HW test and review stay with the orchestrator.
Record candidates go to the archivist immediately (domain_archivist_candidates_sent_immediately_2026_10_23).
