id: todo_t585_pmic_reset_test_numbered_images_flash_panfrost_2026_10_24
type: todo
area: mainline
perspective: user
created: 1792867170.32666
edges: [{"target_id": "learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24", "edge_type": "related"}]
cue: You pick the next SM-T585 task after pwrkeyd and charger zones, or plan a PMIC reset test or boot flash.
---

TODO (user-confirmed order, 2026-10-24):
1. PMIC reset test: stop pwrkeyd, hold only Power for about 15 s. A reboot means 1-key reset, no reboot means 2-key (see learning_t585_s2mpu05_manual_reset_regs_2key_2026_10_24).
2. build-stage1.sh keeps a numbered copy boot-stage1-k<N>.img automatically (#30 was lost because boot-stage1.img gets overwritten).
3. Rebuild and flash so that BOOT matches the commits.
4. Panfrost.
Items 1-4 of domain_priority_dtbs_check_charger_zones_pwrbtn_panfrost_bt_2026_10_24 are done (dtbs_check in a1cf85447/3ece1d800, charger findings in aa17ce4a9, zones verified, pwrkeyd).
