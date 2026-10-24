id: learning_kconfig_fragment_typo_silently_ignored_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792862243.584615
cue: You added a CONFIG_ line to a kernel config fragment and the feature is missing after the build.
---

Observed: A Kconfig fragment merged with merge_config.sh silently ignores a misspelled symbol. We wrote THERMAL_GENERIC_ADC; the real symbol is GENERIC_ADC_THERMAL. The only sign is that the option is missing in the resulting .config.
Cause: merge_config.sh/olddefconfig drop symbols that do not exist without an error.
Evidence: kernel/gtaxllte-stage1.config, build of kernel #30. Rule: after adding a symbol to gtaxllte-stage1.config, grep the final .config for it.
