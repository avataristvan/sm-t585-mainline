id: pattern_check_iio_consumer_values_after_provider_dt_change_2026_10_24
type: pattern
area: mainline
perspective: agent
created: 1792867169.084954
edges: [{"target_id": "learning_t585_adc_vdd_supply_switches_consumers_to_mv_2026_10_24", "edge_type": "confirms"}]
cue: You flash a DT change that touches &adc or another IIO provider (supply, scale) and are about to trust the image.
---

Rule: After a DT change that alters an IIO provider (supply, scale), read the consumer values (e.g. the battery NTC temperature) on the device before trusting the image.
When: Before and right after flashing a DT that touches &adc or other IIO providers.
Why: dtbs_check cannot catch unit changes. The ADC vdd-supply turned the NTC into 62.6 C on the first #31 boot (learning_t585_adc_vdd_supply_switches_consumers_to_mv_2026_10_24).
