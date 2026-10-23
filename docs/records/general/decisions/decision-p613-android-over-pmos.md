id: decision-p613-android-over-pmos
type: domain
area: general
created: 1789810754.023045
edges: [{"target_id": "domain_t585_lean_linux_music_device_2026_10_23", "edge_type": "related"}, {"target_id": "domain_target_device_sm_t585_2026_10_23", "edge_type": "related"}]
---

Decision: Guiding decision (2026-09-19): the newer tablet SM-P613 (Galaxy Tab S6 Lite 2022, Qualcomm, gta4xlveu) with current Android (unofficial LineageOS 23 by daniml3, XDA thread 4752160) is a better path than a native-Linux port of the SM-T580. The user installs that Android themselves; it is NOT work for the galaxy-tab-a-10 repo. No context switch — this repo stays a side project. (Update 2026-10-23: the repo was reopened for the SM-T585 lean-Linux music device, see domain_t585_lean_linux_music_device_2026_10_23; the device is an SM-T585, not an SM-T580, see domain_target_device_sm_t585_2026_10_23.) A mini HTML server on the tablet was mentioned as an interesting idea (approach undecided), but is outside this repo.
Why: T580 pmOS port is archived/fragile (downstream 3.18, mostly untested); P613 has working hardware and an active maintainer. pmOS status for P613 was not checked.
Scope: galaxy-tab-a-10 repo; recorded in its CLAUDE.md under 'Guiding decision'.