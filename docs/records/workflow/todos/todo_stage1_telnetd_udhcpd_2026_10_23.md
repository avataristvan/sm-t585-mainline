id: todo_stage1_telnetd_udhcpd_2026_10_23
type: todo
area: workflow
perspective: user
created: 1792773116.315496
edges: [{"target_id": "learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23", "edge_type": "related"}]
cue: You want a network shell instead of USB-ACM on the SM-T585 stage 1.
---

TODO: Add telnetd and udhcpd to the stage-1 initramfs. The static Alpine busybox lacks them; take them from busybox-extras or build a busybox that includes them.
