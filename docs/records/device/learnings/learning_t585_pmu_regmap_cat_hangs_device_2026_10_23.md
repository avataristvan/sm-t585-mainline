id: learning_t585_pmu_regmap_cat_hangs_device_2026_10_23
type: learning
area: device
perspective: the-coder
created: 1792786773.80855
edges: [{"target_id": "learning_t585_clk_summary_reboots_2026_10_23", "edge_type": "related"}, {"target_id": "pattern_dump_downstream_regmap_when_port_silent_2026_10_23", "edge_type": "related"}]
cue: You are about to cat a whole /d/regmap/*/registers file or clk_summary on the downstream Lineage kernel of the SM-T585.
---

Observed: Under Lineage (downstream 3.18), `cat /d/regmap/10480000.system-controller/registers` (PMU syscon regmap, 64 KiB range) hung the whole tablet: adb vanished and the user had to hard power off. The user first thought the sine playback caused it, but playback had been running fine for several seconds; the hang started with this dump.
Cause: Reading the full PMU regmap on the downstream kernel hits registers that lock the bus, same hazard class as clk_summary. Never dump the full PMU regmap there; read single PMU registers only (targeted tool). Other regmaps (14880000.s1402x, 5-001b) dump fine. This corrects the wording "hangs (too large)" in pattern_dump_downstream_regmap_when_port_silent_2026_10_23, which could not be rewritten (unversioned area).
Evidence: session 2026-10-23 (audio chunk 3c), user report.
