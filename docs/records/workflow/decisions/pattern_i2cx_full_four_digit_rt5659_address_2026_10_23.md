id: pattern_i2cx_full_four_digit_rt5659_address_2026_10_23
type: pattern
area: workflow
perspective: agent
created: 1792791130.008845
edges: [{"target_id": "learning_t585_i2cx_rt5659_register_access_2026_10_23", "edge_type": "related"}]
cue: You are about to type an i2cx read or write for an RT5659 register above 0x00ff on the SM-T585.
---

Rule: Always give the full 4-hex-digit RT5659 register address to i2cx. Read: `i2cx 2 1b <addr-hi> <addr-lo> r2`; write: `i2cx 2 1b <addr-hi> <addr-lo> <data-hi> <data-lo>` (bus 2, slave 0x1b, 16-bit address and data, big endian).
When: Every manual RT5659 poke, especially registers like CLASSD_2 0x011c.
Why: Mistake made: passing `00 1c` instead of `01 1c` for CLASSD_2 (0x011c) hit STO1 ADC volume 0x001c instead; harmless this time, but a wrong write can change an unrelated register silently.
