id: domain_t585_camera_not_realistic_2026_10_25
type: domain
area: goal
perspective: user
created: 1792956333.163663
edges: [{"target_id": "domain_t585_general_lean_tablet_not_music_only_2026_10_25", "edge_type": "related"}, {"target_id": "domain_t585_standard_linux_interfaces_except_audio_2026_10_27", "edge_type": "related"}]
cue: You consider a camera app or camera support for the SM-T585 on mainline Linux and wonder whether that is realistic.
---

Decision: A camera is not a goal for the SM-T585 on mainline Linux. It is not realistic.
Why: There is no mainline Exynos 7870 camera driver (the FIMC-IS camera path is missing upstream). Set by the user on 2026-10-25.
Scope: The general-tablet goal, domain_t585_general_lean_tablet_not_music_only_2026_10_25.
