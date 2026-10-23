id: learning_t585_poweroff_f_works_stage1_2026_10_23
type: learning
area: mainline
perspective: user
created: 1792778779.013298
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}]
cue: You need to switch the SM-T585 off from the stage-1 Linux shell, or a long power-key press reboots it instead.
---

Observed: On stage 1 (mainline 7.3), `poweroff -f` from the shell switched the SM-T585 off (user confirmed, 2026-10-23 20:05). A long press of the power key reboots the device instead; the PMIC manual reset causes that reboot. Earlier on 2026-10-23 a plain `poweroff` (without -f) was reported to end in a reboot or hang; that was not retested after the -f result.
Cause: Not investigated. The power-off path that works is probably the syscon-poweroff handler (PS_HOLD) from the Exynos syscon restart DTSI, but this is not verified against the board DTS or the downstream PS_HOLD offset.
Evidence: user test report 2026-10-23 20:05 (stage-1 shell, `poweroff -f`); no source file.
