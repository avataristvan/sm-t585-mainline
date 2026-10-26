id: learning_t585_samsung_dsim_transfer_needs_prepare_prev_first_2026_10_26
type: learning
area: mainline
perspective: agent
created: 1792976190.275604
edges: [{"target_id": "domain_t585_dsi_panel_own_driver_hx8279d_2026_10_26", "edge_type": "related"}]
cue: Your DSI panel sends DCS or vendor commands in prepare and the transfer fails or times out on samsung-dsim.
---

Observed: samsung-dsim host_transfer only works after the host's pre_enable (state DSIM_STATE_ENABLED). A panel that sends DSI commands in prepare therefore needs panel->prepare_prev_first = true.
Cause: Without it the panel prepare runs before the DSI host is enabled, so the host rejects transfers.
Evidence: drivers/gpu/drm/bridge/samsung-dsim.c and panel-samsung-gtaxllte-hx8279d.c (2026-10-26); read from code, not yet verified on hardware.
