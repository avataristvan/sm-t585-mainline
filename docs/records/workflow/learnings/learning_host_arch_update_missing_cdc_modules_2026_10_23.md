id: learning_host_arch_update_missing_cdc_modules_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792769207.037038
edges: [{"target_id": "learning_mainline_stage1_boot_t585_2026_10_23", "edge_type": "related"}]
cue: The SM-T585 gadget shows up over USB but no network or ACM device appears on the host after a system update.
---

Observed: After an Arch kernel update without reboot, the cdc_ncm/cdc_acm modules are missing for the running kernel, so the device's NCM/ACM gadget gets no host driver. The device's ACM shell is still reachable from userspace via libusb/pyusb (kernel/tools/acm-shell.py).
Cause: modules of the new kernel package replaced those of the still-running kernel.
Evidence: kernel/tools/acm-shell.py; session 2026-10-23.
