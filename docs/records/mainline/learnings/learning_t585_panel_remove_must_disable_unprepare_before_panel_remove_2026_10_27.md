id: learning_t585_panel_remove_must_disable_unprepare_before_panel_remove_2026_10_27
type: learning
area: mainline
perspective: agent
created: 1793001886.522265
edges: [{"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}]
cue: Your drm panel driver .remove or rmmod leaves the rail on or WARNs about regulator enable counts at devm release.
---

Observed: A drm panel driver's .remove must call drm_panel_disable and drm_panel_unprepare before drm_panel_remove. Otherwise the regulator enable counts are still above 0 when devm releases the supplies (WARN) and the rail stays on. Applied in panel-samsung-gtaxllte-hx8279d; rmmod now darkens the panel.
Cause: devm regulator release runs after .remove and does not disable a rail whose enable count is held by a still-prepared panel.
Evidence: drivers/gpu/drm/panel/panel-samsung-gtaxllte-hx8279d.c in src/mainline; untested on HW (2026-10-27).
