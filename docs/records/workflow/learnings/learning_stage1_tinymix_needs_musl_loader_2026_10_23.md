id: learning_stage1_tinymix_needs_musl_loader_2026_10_23
type: learning
area: workflow
perspective: the-coder
created: 1792786744.006977
edges: [{"target_id": "learning_tinyplay_alpine_2_0_broken_use_pcmplay_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23", "edge_type": "related"}, {"target_id": "learning_stage1_tinymix_needs_subcommand_2026_10_24", "edge_type": "related"}]
cue: tinymix (Alpine) fails to start on the stage-1 SM-T585 initramfs, or you need to load the sound modules and route headphones on stage 1.
---

Observed: Alpine tinymix on stage 1 needs /lib/ld-musl-aarch64.so.1 plus a symlink /lib/libc.musl-aarch64.so.1. kernel/out/alsa/setup.sh (run on the device as `wget -qO- http://172.16.42.2:8000/alsa/setup.sh | sh`) now fetches the modules and tools, loads them and routes the headphones.
Cause: The static busybox initramfs has no musl loader; dynamic Alpine tools need it fetched.
Evidence: kernel/out/alsa/setup.sh.
