id: learning_stage1_busybox_lacks_telnetd_udhcpd_2026_10_23
type: learning
area: workflow
perspective: agent
created: 1792770176.849228
superseded_by: learning_stage1_telnetd_udhcpd_via_busybox_extras_2026_10_23
valid_until: 1792791388.397234
cue: You try telnet or DHCP into the SM-T585 stage-1 shell over USB NCM and nothing answers, or you set up the host side of the link.
---

Observed: The static Alpine busybox in the stage-1 initramfs (kernel/prebuilt/busybox-1.37.0-r31-aarch64-static) contains neither telnetd nor udhcpd (they are in Alpine's busybox-extras). So the stage-1 telnet shell and DHCP never worked. Access works via USB-ACM (/dev/ttyACM0; the user has access without sudo). The NCM link needs a static IP on the host: a NetworkManager profile "t585-usb" (172.16.42.2/24 on the NCM interface) was created with nmcli without sudo (sudo needs a password).
Cause: busybox-extras was not used; the applets were assumed present.
Evidence: kernel/prebuilt/busybox-1.37.0-r31-aarch64-static; session 2026-10-23.
