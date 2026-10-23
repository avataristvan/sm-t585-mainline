id: todo_t585_speaker_lineage_reference_dump_2026_10_23
type: todo
area: mainline
perspective: agent
created: 1792791129.811325
edges: [{"target_id": "learning_t585_speaker_silent_clicks_only_mainline_2026_10_23", "edge_type": "derived_from"}]
cue: You are about to guess more RT5659 speaker settings on the SM-T585 instead of comparing against a working Lineage register state.
---

TODO: Speakers: reference first, not more guessing. Flash the Lineage boot image temporarily, dump the full RT5659 regmap during speaker playback, and diff it against mainline. This also confirms the speaker hardware works (unknown whether the speakers were ever tested under Lineage on this unit; ask the user). Do it when loudness is acceptable (not while someone sleeps). Afterwards fold the working runtime speaker tinymix settings into kernel/out/alsa/setup.sh.
Context: learning_t585_speaker_silent_clicks_only_mainline_2026_10_23.
