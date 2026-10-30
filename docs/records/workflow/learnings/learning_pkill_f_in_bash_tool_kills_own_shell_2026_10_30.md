id: learning_pkill_f_in_bash_tool_kills_own_shell_2026_10_30
type: learning
area: workflow
perspective: agent
created: 1793346589.244987
cue: You stop background helper scripts with pkill -f from a Bash tool call.
---

Observed: `pkill -f <name>` run from a Bash tool call killed its own shell (exit 144).
Cause: The shell's command line contains the same name, so -f matches it.
Evidence: session 2026-10-30
