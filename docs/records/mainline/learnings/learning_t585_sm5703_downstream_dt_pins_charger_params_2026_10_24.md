id: learning_t585_sm5703_downstream_dt_pins_charger_params_2026_10_24
type: learning
area: mainline
perspective: agent
created: 1792858049.857498
edges: [{"target_id": "learning_t585_sm5703_lineage_charge_reference_2026_10_24", "edge_type": "related"}]
cue: You are writing the SM5703 charger/MFD DT node or driver and need the downstream IRQ, reset, chg_en pins and charger parameters.
---

Observed: Downstream DT: SM5703 MFD @0x49 irq gpa2-7, mrstb gpc7-4, chg_en pin gpd1-3 (output, polarity 0 = active low); MUIC irq gpa2-6 (pull-up); charger float 4300 mV, topoff/full_check 375 mA, chg_autostop=1, chg_autoset=1, aiclen=0, aiclth=4500.
Cause: Values set by the downstream board DT for gtaxllte.
Evidence: src/downstream-lineage-21 exynos7870-gtaxllte_eur_open_05.dts and exynos7870-gtaxllte_eur_open_battery_05.dtsi.
