id: learning_dri_devel_patches_fetch_via_mail_archive_lore_bot_gated_2026_10_27
type: learning
area: workflow
perspective: agent
created: 1793045943.315899
edges: [{"target_id": "learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27", "edge_type": "related"}]
cue: You want to download an upstream kernel patch series (lore, patchwork) to apply it and curl or WebFetch is refused.
---

Observed: lore.kernel.org, patchwork and ratatoskr are bot-gated for curl/WebFetch. dri-devel patches are fetchable from mail-archive.com (per-message HTML, with a browser User-Agent), but the lines come wrapped and tabs expanded, so the patch must be repaired before `git apply`.
Cause: bot protection on the kernel archives; mail-archive.com renders mail as HTML.
Evidence: HW/dev session 2026-10-27, fetching Kaustabh Chakraborty's Exynos 7870 DSIM series (see learning_t585_dsi_hang_narrowed_to_pre_enable_2026_10_27).
