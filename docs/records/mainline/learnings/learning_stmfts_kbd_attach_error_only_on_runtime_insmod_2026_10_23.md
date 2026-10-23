id: learning_stmfts_kbd_attach_error_only_on_runtime_insmod_2026_10_23
type: learning
area: mainline
perspective: agent
created: 1792773116.685969
edges: [{"target_id": "todo_stmfts_pm_runtime_before_register_2026_10_23", "edge_type": "related"}]
cue: You check whether the stmfts pm_runtime ordering fix is needed, or try to reproduce the "failed to attach handler kbd" message.
---

Observed: With stmfts built in (=y) the "failed to attach handler kbd ... -13" message does not appear at boot. It shows only when stmfts is insmodded at runtime.
Cause: at runtime the kbd handler is already registered and opens the new device right after input_register_device(), before pm_runtime_enable(). At built-in boot the handler is not yet there. The ordering bug still exists.
Evidence: boot of kernel #3 (boot image sha1 6829027dee02bf470dcc9494d8e66c93d79780d1), dmesg.
