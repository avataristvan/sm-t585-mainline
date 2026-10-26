id: learning_t585_lineage_userdata_ext4_quota_needs_qfmt_v2_2026_10_25
type: learning
area: mainline
perspective: agent
created: 1792923330.814878
edges: [{"target_id": "domain_kernel_trim_chunk2_builtin_pins_by_reason_2026_10_24", "edge_type": "related"}]
cue: Mounting the Lineage data partition read-write from stage 1 fails with a quota error, and you wonder what the kernel lacks.
---

Observed: Lineage 21 userdata (mmcblk0p23) is ext4 with the quota feature (incompat 0x10246, including encrypt, no casefold). On our kernel a ro,noload mount works as is. A rw mount failed with "The kernel was not built with CONFIG_QUOTA and CONFIG_QFMT_V2". Adding CONFIG_QFMT_V2 to kernel/gtaxllte-builtin.config fixed the rw mount (kernel #33). The FBE encrypt feature does not block the mount without CONFIG_FS_ENCRYPTION, and a directory we create (/data/gtaxl) is unencrypted and usable.
Cause: a rw mount of a quota-enabled filesystem needs the quota format driver in the kernel; a ro,noload mount does not. Without CONFIG_FS_ENCRYPTION the encrypt feature is only a flag; plain directories work.
Not verified: that Lineage tolerates the foreign unencrypted /data/gtaxl at its next boot.
Evidence: kernel/gtaxllte-builtin.config (CONFIG_QFMT_V2 line); mount error and rw mount on kernel #33, 2026-10-25 (terminal output, not kept under docs/sources).
