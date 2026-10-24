id: learning_coder_subagent_brief_ask_make_modules_2026_10_24
type: learning
area: workflow
perspective: agent
created: 1792862243.793047
edges: [{"target_id": "domain_delegate_side_todos_to_smaller_models_2026_10_23", "edge_type": "related"}]
cue: You brief a coder subagent (e.g. Sonnet) to write kernel module code and decide how it verifies the result.
---

Observed: Delegating self-contained driver code to a Sonnet the-coder with a tight brief (file, properties, hysteresis, verify by building one object) worked for chunk 3b (limiter) and 3c (NTC zones); the orchestrator reviews and does the HW test. Sonnet missed MODULE_IMPORT_NS("IIO_CONSUMER") because building only the .o does not run modpost.
Cause: namespace import errors only show at modpost/module link time.
Evidence: src/mainline commit ebba667ea; user asked on 2026-10-24 whether Sonnet as coder is cheaper. Rule: briefs ask for `make modules` (or the .ko), not only the .o.
