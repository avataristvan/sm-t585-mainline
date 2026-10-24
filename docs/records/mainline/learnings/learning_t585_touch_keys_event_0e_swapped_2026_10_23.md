id: learning_t585_touch_keys_event_0e_swapped_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792772532.455449
edges: [{"target_id": "learning_t585_touch_works_stmfts_fts1a096_2026_10_23", "edge_type": "related"}, {"target_id": "domain_t585_touch_keys_menu_left_back_right_2026_10_23", "edge_type": "related"}]
cue: You are mapping the SM-T585 capacitive keys left/right of Home to key codes under mainline stmfts.
---

Observed: The capacitive touch keys left and right of the physical Home key report event 0x0E with a bitmask in byte 2: left key = 0x02, right key = 0x01 (downstream: 0x02 KEY_RECENT, 0x01 KEY_BACK). Mainline stmfts maps 0x01 -> KEY_MENU and 0x02 -> KEY_BACK, so under mainline left = KEY_BACK and right = KEY_MENU, swapped versus the Android labels. The user decided the mapping (left = KEY_MENU, right = KEY_BACK) in domain_t585_touch_keys_menu_left_back_right_2026_10_23.
Cause: mainline stmfts uses its own bit-to-keycode map, not the downstream one.
Evidence: hardware test 2026-10-23 on SM-T585; downstream fts7 key mapping; mainline stmfts.c.
