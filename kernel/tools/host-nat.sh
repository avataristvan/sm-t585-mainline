#!/bin/sh
# Give the tablet internet through this PC: NAT 172.16.42.0/24 (USB NCM) out
# of <uplink>. Docker sets the FORWARD policy to DROP, hence the two accepts.
# Lasts until the PC reboots. Run as root:
#   host-nat.sh [uplink]          default: wlan0
set -eu
UP=${1:-wlan0}
sysctl -q net.ipv4.ip_forward=1
nft list table ip gtaxl >/dev/null 2>&1 || {
	nft add table ip gtaxl
	nft add chain ip gtaxl post '{ type nat hook postrouting priority 100; }'
	nft add rule ip gtaxl post ip saddr 172.16.42.0/24 oifname "$UP" masquerade
}
iptables -C FORWARD -s 172.16.42.0/24 -j ACCEPT 2>/dev/null ||
	iptables -I FORWARD -s 172.16.42.0/24 -j ACCEPT
iptables -C FORWARD -d 172.16.42.0/24 -j ACCEPT 2>/dev/null ||
	iptables -I FORWARD -d 172.16.42.0/24 -j ACCEPT
