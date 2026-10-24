id: learning_trim_check_selected_subsystems_vanish_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792832533.683633
edges: [{"target_id": "learning_dropping_drivers_removes_selected_core_options_2026_10_24", "edge_type": "confirms"}, {"target_id": "domain_kernel_trim_chunk3_defconfig_ballast_off_2026_10_24", "edge_type": "related"}]
cue: You finished trimming kernel config options and want to know if the result silently lost a subsystem before flashing.
---

Observed: Second occurrence, worse. In trim chunk 3, dropping defconfig =y options also removed whole subsystems whose menu symbols arm64 defconfig never sets itself because some driver always selected them: REGULATOR (would have killed the S2MPS11 PMIC regulators), RESET_CONTROLLER/RESET_SIMPLE (simple-reset is bound on the device), CRYPTO (the entire crypto API).
Cause: Kconfig `select` chains again: the subsystem was =y only through selecting drivers; turning those off drops it without error.
Evidence: kernel/gtaxllte-builtin.config (now has a dedicated group pinning these); session 2026-10-24; confirms learning_dropping_drivers_removes_selected_core_options_2026_10_24. Rule after any trim, run all three: (a) the =m set is unchanged; (b) every =y line in the fragments is still =y in .config; (c) before/after =y diff minus the symbols listed in the fragments, and review the rest by hand.
