id: pattern_t585_pmos_install_via_recovery_zip_2026_10_25
type: pattern
area: goal
perspective: agent
created: 1792956689.080283
edges: [{"target_id": "pattern_t585_pmos_post_install_checklist_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_pmos_in_userdata_pmaports_model_2026_10_26", "edge_type": "related"}]
cue: You install postmarketOS onto the SM-T585 with the recovery zip while Lineage is on the device and wonder what to flash by hand.
---

Rule: Install pmOS into Lineage's SYSTEM partition with pmbootstrap install --android-recovery-zip --recovery-install-partition=system --recovery-no-kernel. Install the zip it produces through TWRP via adb (twrp install). Write BOOT by hand with dd. Then run the post-install checklist, pattern_t585_pmos_post_install_checklist_2026_10_25.
When: installing or reinstalling pmOS on the SM-T585 while Lineage is on the device.
Why: --recovery-no-kernel leaves the kernel out of the zip, so BOOT is written by hand with dd.
