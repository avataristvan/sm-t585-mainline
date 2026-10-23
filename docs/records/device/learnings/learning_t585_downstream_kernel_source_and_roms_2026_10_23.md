id: learning_t585_downstream_kernel_source_and_roms_2026_10_23
type: learning
area: device
perspective: agent
created: 1792769192.724335
edges: [{"target_id": "domain_target_device_sm_t585_2026_10_23", "edge_type": "related"}]
cue: You need the working downstream kernel source, defconfig, board DTS, stock firmware version or ROM files for gtaxllte/gtaxlwifi.
---

Observed: Working downstream kernel for gtaxllte/gtaxlwifi: github.com/Exynos7870-labs/android_kernel_samsung_exynos7870, branch lineage-21 (contains the running commit e2426d3c1cef; defconfigs lineage-gtaxl{lte,wifi}_defconfig; board DTS exynos7870-gtaxllte_eur_open_05.dts plus exynos7870-gtaxl_common.dtsi). Cloned to src/downstream-lineage-21. Stock firmware/bootloader version: T585XXS7CUI2. The ROM folder "samsung galaxy tab a (2016)/" holds LineageOS 19.1-21 and /e/ builds for gtaxllte, TWRP 3.7.0 and NikGapps, plus a personal invoice.pdf that must stay out of any VCS. The device runs LineageOS 21 (not 22).
Cause: n/a (reference facts).
Evidence: device dump device-dump/sm-t585/, src/downstream-lineage-21, 2026-10-23.
