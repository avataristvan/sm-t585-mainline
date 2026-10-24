id: learning_rt5659_driver_gpio_names_unprefixed_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792774428.16664
edges: [{"target_id": "learning_t585_rt5659_codec_probes_mainline_2026_10_23", "edge_type": "related"}, {"target_id": "learning_t585_dtbs_check_clean_local_bindings_2026_10_24", "edge_type": "related"}]
cue: You write an rt5659 codec DTS node with ldo1-en/reset GPIOs and the binding or dtbs_check says different property names.
---

Observed: sound/soc/codecs/rt5659.c requests the GPIOs "ldo1-en" and "reset" (properties ldo1-en-gpios / reset-gpios), but the binding realtek,rt5659.yaml documents realtek,ldo1-en-gpios / realtek,reset-gpios. gpiolib-of has no quirk mapping the prefixed names, so they are silently ignored. Our DTS therefore uses the unprefixed names; dtbs_check will flag them. No upstreaming planned.
Cause: mainline driver and binding disagree (mainline bug).
Evidence: sound/soc/codecs/rt5659.c and Documentation/devicetree/bindings/sound/realtek,rt5659.yaml in src/mainline; working probe in learning_t585_rt5659_codec_probes_mainline_2026_10_23.
