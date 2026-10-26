id: learning_t585_sm5703_fg_status_follows_charger_verified_hw_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1793051249.474246
edges: [{"target_id": "domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27", "edge_type": "derived_from"}, {"target_id": "learning_t585_sm5703_charger_base_verified_hw_kernel28_2026_10_24", "edge_type": "related"}]
cue: You check on HW that the SM-T585 gauge STATUS follows the charger on plug/unplug, or wonder why Not charging shows ~4 s after unplug.
---

Observed: HW-verified 2026-10-26 (kernel 7.3.0-gtaxllte #7 pmOS, test FG module in /lib/modules/.../updates, new DTB in /boot, old DTB kept as .pre-fglink). Plugged on a PC port the gauge reports Charging at net -47 mA (before: Discharging). Unplug/replug: gauge follows the charger (Charging -> Not charging ~4 s -> Discharging -> Charging). Each charger uevent is followed by a gauge uevent within ~10 ms, so external_power_changed works. Minor: the gauge poll sends a second uevent a few seconds later (its cached state is not updated by the external_power_changed path); harmless.
Cause: the ~4 s "Not charging" after unplug comes from the charger's cached `online` (5 s poll) while STATUS3 is read live. The remaining lag is audit #4's MUIC-IRQ part (still open).
Evidence: record domain_t585_sm5703_fg_status_from_charger_supplier_2026_10_27; HW session 2026-10-26 (uevent timings).
