id: domain_t585_build_stage1_boot_image_letter_suffix_2026_10_24
type: domain
area: mainline
perspective: agent
created: 1792875780.48579
edges: [{"target_id": "domain_t585_build_stage1_numbered_boot_images_2026_10_24", "edge_type": "supersedes"}, {"target_id": "learning_t585_build_stage1_same_version_overwrites_boot_image_2026_10_24", "edge_type": "derived_from"}, {"target_id": "domain_t585_build_stage1_numbered_boot_images_2026_10_24", "edge_type": "related"}]
cue: You rebuild the SM-T585 stage-1 image without a new kernel version and want the earlier numbered boot image kept, not overwritten.
---

Decision: kernel/build-stage1.sh copies every built image to kernel/out/boot-stage1-k<N>.img, with N read from <kernel-out>/.version (the #N of uname -v). When that name already exists and differs, the script appends a letter (k32b, k32c, ...). When the file is identical, it skips the copy.
Why: Each build used to overwrite boot-stage1.img, so the #30 image was lost. Later, a DTB-only or initramfs-only rebuild kept the same #N and overwrote boot-stage1-k32.img (learning_t585_build_stage1_same_version_overwrites_boot_image_2026_10_24). The letter keeps every image.
Scope: Build tooling, kernel/build-stage1.sh (SM-T585 mainline stage 1). Part of todo_t585_pmic_reset_test_numbered_images_flash_panfrost_2026_10_24 (item 2). Replaces domain_t585_build_stage1_numbered_boot_images_2026_10_24, which lacked the letter rule.
