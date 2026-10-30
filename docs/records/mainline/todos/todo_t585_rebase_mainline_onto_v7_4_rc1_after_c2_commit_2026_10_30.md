id: todo_t585_rebase_mainline_onto_v7_4_rc1_after_c2_commit_2026_10_30
type: todo
area: mainline
perspective: user
created: 1793341581.805926
cue: You plan a kernel base update or prepare SM-T585 patches for upstream submission.
---

TODO: once v7.4-rc1 is tagged, rebase src/mainline branch gtaxllte onto it (shallow clone: fetch the base first), rebuild, short HW regression (boot, WiFi, BT, suspend, load). Decided with the user: not during the C2 debug, only after the C2 fix is committed. Downstream lineage-21 needs no update (remote = local b8027e71, last commit 2025-03).
