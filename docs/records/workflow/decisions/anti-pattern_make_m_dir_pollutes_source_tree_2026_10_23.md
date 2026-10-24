id: anti-pattern_make_m_dir_pollutes_source_tree_2026_10_23
type: anti-pattern
area: workflow
perspective: agent
created: 1792778220.81494
cue: You want to rebuild a single kernel module quickly with make M=<dir> for the SM-T585.
---

Tried: Building modules with `make M=<dir>` (e.g. `make M=sound/soc/samsung`) with a relative O=.
Failed because: It wrote build artefacts into the source tree (src/mainline/sound/soc/samsung), polluting it.
Instead: Use the full `make O=... modules` target (see Build & flash in CLAUDE.md, O=../../kernel/build); ccache keeps it fast. Clean a polluted tree with `git clean -fdX sound/soc/samsung`.
