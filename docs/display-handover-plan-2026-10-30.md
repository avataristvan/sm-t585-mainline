# Display handover plan (2026-10-30)

Goal: after every boot GDM finds the panel (no black screen), and the firmware framebuffer
(simpledrm) is handed over to exynos-drm instead of staying as a second DRM card. Scope:
pmOS device package (initramfs modules), kernel config (exynos-drm built-in → module), board
DTS (`sysmmu_decon`). SysMMU for DECON (enabling `CONFIG_EXYNOS_IOMMU`) is a separate chapter
afterwards.

## Facts

- Since HS200 GDM starts at ~19–21 s. Boots where GNOME Shell came before the panel: black screen
  ("No GPUs with outputs found" / "primaryMonitor is null"); `systemctl restart gdm` brings the
  login. The r15 boot only worked because GDM came late (97 s).
- Three mechanisms overlap:
  1. **DECON waits for an IOMMU that never comes.** `decon` has `iommus = <&sysmmu_decon>`, the
     sysmmu node is enabled, `CONFIG_EXYNOS_IOMMU` is off (bypass by design, CMA buffers) →
     fw_devlink/of_iommu defer DECON until the deferred-probe timeout ("deferred probe timeout,
     ignoring dependency"), exynos-drm registers at ~24 s.
  2. **The panel driver is a module from the rootfs.** Root switch at 6.3 s, panel attach
     (`samsung_dsim_host_attach`) at 12.4 s. Until then exynos-drm has no connector. GDM before
     12 s → black even when exynos-drm itself is early.
  3. **simpledrm handover depends on probe order.** exynos-drm calls
     `aperture_remove_conflicting_devices()` in its bind. Both are built-in and exynos is linked
     before `sysfb/` in `drivers/gpu/drm/Makefile`; `sysfb_disable()` only blocks later
     *sysfb*-created devices (EFI/x86), not a DT `simple-framebuffer` node. With mechanism 1
     removed (test: `&sysmmu_decon { status = "disabled"; }`), exynos-drm registers at 0.238 s,
     simpledrm at 0.239 s → simpledrm is never removed; mutter adds it as a second GPU
     (`card1`, connector `Unknown-1`, "Created gbm renderer for /dev/dri/card1"). Without the
     test DTB the 24 s delay hid this.
- pmOS mechanism: a `modules-initfs` file in the device package is installed to
  `/usr/share/mkinitfs/modules/` (devicepkg-dev), mkinitfs puts the modules into the initramfs
  and `init.sh` loads them (`load_modules /lib/modules/initramfs.load`) before
  `setup_framebuffer` and the root mount. Precedent: archived device-samsung-a5 lists its
  panel module and `msm`.
- The panel module has no module dependencies; its backlight is DSI-controlled
  (`14800000.dsi.0`), supplies come from the built-in PMIC.
- `kernel/gtaxllte-builtin.config` keeps `DRM_EXYNOS=y` from the 2026-10-23 trim policy ("this
  SoC stays =y"); the 2026-10-26 decision allows modules where sensible. Panfrost (render-only,
  no aperture) can stay built-in. The stage-1 image uses the same merged config but loads no
  modules from a rootfs: with exynos-drm as a module stage-1 shows the simpledrm console on the
  bootloader's still-running scanout (which is what it had before DSI worked).

## Hypotheses

- **H-1** With the panel module in the initramfs, the panel attaches before the root switch
  (< 6 s), so GDM always finds a connector.
- **H-2** With exynos-drm as a module loaded from the initramfs, simpledrm (built-in, 0.24 s) is
  registered first and exynos-drm removes it at bind: one DRM card with outputs (`card0`?),
  no `simple-framebuffer` card, early console visible until the handover.
- **H-3** `sysmmu_decon` disabled is still needed with H-2: otherwise the module's DECON probe
  waits for the deferred-probe timeout (~10 s after late init), past the root switch.

## Steps

| # | Change | How to test | Predicted |
|---|---|---|---|
| H1 | `/etc/mkinitfs/modules/gtaxllte-display.modules` = panel module; `mkinitfs` on the tablet (r15 kernel modules, current test kernel) | reboot ×3, journal monotonic times | panel attach < 6 s, GDM finds `card0` every time; simpledrm still stays (mechanism 3 unchanged) |
| H2 | `DRM_EXYNOS=m` in `gtaxllte-pmos.config`, device package `modules-initfs` (exynosdrm + panel), sysmmu_decon disabled, D1/D2 included → test package r16 built by the user | reboot ×3 | one display card + panfrost, no simpledrm card after the handover, console visible early, login every time |
| H3 | only for the record: same package with `sysmmu_decon` enabled | one boot | DECON waits for the timeout again (H-3) |

H1 is an on-device change (reverted by deleting the file and running `mkinitfs`); the device
package makes it permanent in H2.

## Risk / restore

- A broken initramfs prevents boot: keep `/boot/initramfs` as `initramfs.r15` before running
  mkinitfs; restore from TWRP (pmOS_boot loop mount) if needed.
- With exynos-drm as a module, a missing module in the initramfs means no panel until udev
  loads it from the rootfs — same as today, no worse.

## Results (2026-10-30)

- **H1 confirmed (3/3 boots):** with `/etc/mkinitfs/modules/gtaxllte-display.modules`
  (panel module) and `mkinitfs`, the module is in the initramfs and loads via modalias during
  coldplug (this mkinitfs writes no `initramfs.load` list). Panel attach at 3.11 s, root switch
  at 6.3–6.5 s, GNOME Shell picks `card0` at ~20.5 s every time; 0 GPU faults. simpledrm still
  stays as `card1` (mechanism 3 unchanged, as predicted).
- Pitfall: `mkinitfs` runs boot-deploy, which reinstalls the package DTB to
  `/boot/exynos7870-gtaxllte.dtb` (overwrote the test DTB with the r15 one; `vmlinuz` was left
  alone). After mkinitfs on a test setup, re-copy the test DTB.
- **H2 confirmed (3/3 boots, linux-samsung-gtaxllte r16 + device-samsung-gtaxllte pkgrel 4):**
  simpledrm registers at 0.19 s (`fb0`), exynos-drm loads from the initramfs at 3.08 s, removes
  it and takes `fb0`; panel attach 3.05–3.16 s, root switch 6.5–6.8 s. DRM devices: `card1`
  panfrost, `card2` exynos-drm (+ `DSI-1`), no simple-framebuffer card. GNOME Shell picks `card2`
  at ~21 s every time; no "Added device … simpledrm". GPU devfreq unchanged, 0 job faults.
- **H3 confirmed (1 boot):** r16 with only `sysmmu_decon` set back to `okay` (fdtput on the
  package DTB): DECON waits for the deferred-probe timeout ("ignoring dependency" at 24.29 s),
  panel attach 24.38 s, GNOME Shell started before it ("primaryMonitor is null") → black screen.
  The `&sysmmu_decon { status = "disabled"; }` line is required as long as
  `CONFIG_EXYNOS_IOMMU` is off.
