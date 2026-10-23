id: learning_name_physical_controls_in_hw_tests_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792772532.648484
edges: [{"target_id": "learning_t585_touch_keys_event_0e_swapped_2026_10_23", "edge_type": "related"}]
cue: You are about to ask the user to press, touch or flip something on the device during a hardware test.
---

Observed: When asking the user to press "the keys" during a hardware test, name them physically (e.g. "the capacitive touch keys left/right of Home", not "both keys"). An ambiguous instruction made the user press volume up/down, which cost three test rounds and two wrong hypotheses (command delays, downstream init order) that were then reverted.
Cause: "the keys" is ambiguous on a device with volume, power, Home and capacitive keys.
Evidence: SM-T585 touch-key test session 2026-10-23; learning_t585_touch_keys_event_0e_swapped_2026_10_23.
