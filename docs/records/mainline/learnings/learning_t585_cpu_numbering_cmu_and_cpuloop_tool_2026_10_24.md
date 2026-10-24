id: learning_t585_cpu_numbering_cmu_and_cpuloop_tool_2026_10_24
type: learning
area: mainline
perspective: the-coder
created: 1792853977.642691
cue: Measuring or pinning a specific CPU cluster frequency on the T585, or mapping a CPU number to its CMU.
---

Observed: CPUs 0-3 (MPIDR 0x0xx) = CMU_CPUCL0 (0x10900000); CPUs 4-7 (MPIDR 0x1xx) = CMU_CPUCL1 (0x10800000). New tool kernel/tools/cpuloop/cpuloop.c (no libc; built with clang --target=aarch64-linux-gnu -nostdlib -static -fuse-ld=lld; binary kernel/out/cpuloop): `cpuloop CPU [MITER]` pins itself with sched_setaffinity and times a subs/b.ne loop that runs 1 iteration per cycle on the A53. 200M iterations: 222.7 ms at 902.2 MHz, 588 ms at 342.875 MHz (= 339.9 MHz measured), 118.6 ms at 1690 MHz (= 1686.9 MHz measured). busybox has no taskset, hence the tool.
Cause: the loop is one cycle per iteration, so time gives the real CPU clock independent of what the clock framework reports.
Evidence: kernel/tools/cpuloop/cpuloop.c, runs on kernel #25.
