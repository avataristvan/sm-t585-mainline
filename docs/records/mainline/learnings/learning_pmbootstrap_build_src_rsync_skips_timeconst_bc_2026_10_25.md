id: learning_pmbootstrap_build_src_rsync_skips_timeconst_bc_2026_10_25
type: learning
area: mainline
perspective: agent
created: 1792956350.365134
cue: You run pmbootstrap build of the kernel from a source tree and it fails with No rule to make target kernel/time/timeconst.bc.
---

Observed: `pmbootstrap build --src` rsyncs the tree with the kernel's .gitignore as its exclude list. rsync ignores git's exception "!kernel/time/timeconst.bc" to the "*.bc" rule, so the file is not copied and the build fails with "No rule to make target kernel/time/timeconst.bc".
Cause: rsync does not apply git's negation patterns the way git does.
Fix: the APKBUILD ships timeconst.bc and copies it in prepare().
Evidence: pmos/linux-samsung-gtaxllte/APKBUILD (prepare()).
