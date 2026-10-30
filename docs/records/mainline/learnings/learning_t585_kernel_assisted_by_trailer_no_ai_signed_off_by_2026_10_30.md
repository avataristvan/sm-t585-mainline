id: learning_t585_kernel_assisted_by_trailer_no_ai_signed_off_by_2026_10_30
type: learning
area: mainline
perspective: agent
created: 1793386848.478547
edges: [{"target_id": "todo_t585_upstream_dwmmc_exynos_extended_tmout_fix_2026_10_30", "edge_type": "related"}]
cue: You prepare any patch for a kernel mailing list, or convert commits that carry Co-Authored-By: Claude for upstream.
---

Observed: The kernel requires an "Assisted-by: LLM [tools]" trailer on AI-assisted patches and forbids an AI-added Signed-off-by; the human submitter adds Signed-off-by. The repo's own commits use Co-Authored-By: Claude, which is fine for the fork but must be converted to Assisted-by for upstream submissions.
Cause: Kernel process rules for AI-generated contributions.
Evidence: Documentation/process/coding-assistants.rst and Documentation/process/generated-content.rst in src/mainline; applied on branch upstream/dwmmc-tmout.
