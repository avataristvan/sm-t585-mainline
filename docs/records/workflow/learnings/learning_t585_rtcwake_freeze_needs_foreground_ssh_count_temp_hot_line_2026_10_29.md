id: learning_t585_rtcwake_freeze_needs_foreground_ssh_count_temp_hot_line_2026_10_29
type: learning
area: workflow
perspective: agent
created: 1793311936.786011
edges: [{"target_id": "learning_t585_s2idle_resume_works_after_charger_poll_freezable_wq_2026_10_29", "edge_type": "related"}, {"target_id": "learning_t585_never_rmmod_charger_host_built_module_fails_btf_package_kernel_2026_10_29", "edge_type": "related"}]
cue: You script an rtcwake suspend test over ssh on the SM-T585, or check for i2c "Transfer while suspended" warnings.
---

Observed: `rtcwake -m freeze` started with nohup or in the background from an ssh session never suspends. "i2c Transfer while suspended" is WARN_ONCE per boot, so it cannot be counted across suspends.
Cause: The background process dies with the ssh session. The warning fires only once per boot.
Instead: run rtcwake in the foreground with an ssh timeout of secs+120; count the charger "temperature unknown: hot" line per suspend instead of the WARN_ONCE.
Evidence: session 2026-10-29, docs/suspend-resume-plan-2026-10-29.md.
