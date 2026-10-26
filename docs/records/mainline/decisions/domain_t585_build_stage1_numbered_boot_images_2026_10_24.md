id: domain_t585_build_stage1_numbered_boot_images_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792875052.547871
superseded_by: domain_t585_build_stage1_boot_image_letter_suffix_2026_10_24
valid_until: 1792875780.811781
cue: You rebuild the SM-T585 stage-1 boot image and want the previous kernel build kept as a fallback to flash.
---

Decision: kernel/build-stage1.sh copies every built image to kernel/out/boot-stage1-k<N>.img, with N read from <kernel-out>/.version (the #N of uname -v).
Why: Each build used to overwrite boot-stage1.img, so #30 was lost. A fallback image per kernel build now exists without manual copies.
Scope: Build tooling, kernel/build-stage1.sh (SM-T585 mainline stage 1). Part of todo_t585_pmic_reset_test_numbered_images_flash_panfrost_2026_10_24 (item 2).
