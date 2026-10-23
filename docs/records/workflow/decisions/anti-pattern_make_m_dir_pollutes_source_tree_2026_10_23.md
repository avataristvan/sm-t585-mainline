id: anti-pattern_make_m_dir_pollutes_source_tree_2026_10_23
type: anti-pattern
area: workflow
perspective: agent
created: 1792778220.81494
cue: You want to rebuild a single kernel module quickly with make M=<dir> for the SM-T585.
---

Tried: Building modules with `make M=<dir>` without matching O= semantics.
Failed because: It wrote artifacts into src/mainline, polluting the source tree.
Instead: Use the full build (see Build & flash in CLAUDE.md, with O=../../kernel/build).
