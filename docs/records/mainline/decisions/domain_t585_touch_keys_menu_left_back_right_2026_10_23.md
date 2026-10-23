id: domain_t585_touch_keys_menu_left_back_right_2026_10_23
type: domain
area: mainline
perspective: user
created: 1792772742.632318
edges: [{"target_id": "learning_t585_touch_keys_event_0e_swapped_2026_10_23", "edge_type": "derived_from"}]
cue: You are changing or upstreaming the stmfts key mapping, or wonder why the SM-T585 left key is KEY_MENU and the right key KEY_BACK.
---

Decision: On the SM-T585 the left capacitive key (left of Home) is KEY_MENU and the right key is KEY_BACK. Implemented in stmfts as a per-chip keymap in struct stmfts_chip_info (keymap[2], indexed by key status bit): FTS1A096 = { KEY_BACK, KEY_MENU } (right = bit0 0x01, left = bit1 0x02); FTS4 keeps { KEY_MENU, KEY_BACK }, behaviour unchanged. Verified on hardware via evdev (left -> KEY_MENU, right -> KEY_BACK), 2026-10-23.
Why: the user's choice for this device, not the Android labels (Recent/Back). It also closes the open keymap point in the learning.
Scope: drivers/input/touchscreen/stmfts in src/mainline, FTS1A096 variant only.
