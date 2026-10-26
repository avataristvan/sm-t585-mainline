id: anti-pattern_uboot_clang_wrapper_build_black_screen_2026_10_25
type: anti-pattern
area: device
perspective: agent
created: 1792963730.94855
edges: [{"target_id": "learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25", "edge_type": "related"}]
cue: You are about to build U-Boot for the SM-T585 with clang or a hand-made cross-toolchain wrapper instead of the GNU cross gcc.
---

Tried: Building U-Boot with clang plus a hand-made aarch64-linux-gnu-* wrapper (lld, llvm-objcopy, clang as "as").
Failed because: It built without errors, but the device showed a black screen from power-on (not even the S-Boot logo) and never enumerated USB. U-Boot's Makefile with CC=clang forces -no-integrated-as and calls $(CROSS_COMPILE)as, so the wrapper's assembler path was not a real GNU one.
Instead: Build U-Boot with the real GNU cross toolchain (Arch extra: aarch64-linux-gnu-gcc 16.2); the same sources then work (see learning_t585_uboot_chainload_runs_bootmenu_fastboot_2026_10_25). The kernel is still built with clang.
