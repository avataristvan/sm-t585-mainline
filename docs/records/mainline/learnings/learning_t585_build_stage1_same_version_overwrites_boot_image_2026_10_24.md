id: learning_t585_build_stage1_same_version_overwrites_boot_image_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792875774.663096
cue: You rebuild only the DTB or initramfs of the SM-T585 stage-1 image and find an older numbered boot image overwritten or changed.
---

Observed: The first version of the numbered copy in kernel/build-stage1.sh named the image from <kernel-out>/.version. A DTB-only or initramfs-only rebuild does not bump that version, so the rebuild overwrote boot-stage1-k32.img. It was restored from a /tmp copy.
Cause: The kernel version (#N) changes only when the kernel itself is rebuilt, not when only the DTB or the initramfs is. Also, gzip output for the initramfs is not byte-reproducible: the ramdisk size varies by a few bytes between builds, so the same sources give a different sha1.
Evidence: kernel/build-stage1.sh (the numbered-copy block); the restored boot-stage1-k32.img. The fix is in domain_t585_build_stage1_boot_image_letter_suffix_2026_10_24.
