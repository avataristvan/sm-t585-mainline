# Commit plan 2026-10-27

Nothing has been committed since 2026-10-24 (`393792e`). Proposal only: no `git add`/`commit` was run.
User controls VCS; commit order below is topic by topic, each commit buildable on its own where possible.

## State at planning time

Main repo (branch `main`): modified `.gitignore`, `CLAUDE.md`, `kernel/build-stage1.sh`, `kernel/gtaxllte-builtin.config`,
`kernel/initramfs/init`, 22 modified + 1 deleted record, 83 untracked records; untracked `apps/`, `pmos/`, `uboot/`,
`kernel/gtaxllte-pmos.config`, `kernel/initramfs/{rootfs-up,rootsh}`, `kernel/tools/{host-nat.sh,mk-panelpwr-dtb.sh,rootfs/}`,
six docs. `src/mainline` shows as modified (see below).

Submodule `src/mainline` (branch `gtaxllte`): HEAD `aa17ce4a9`, **14 commits ahead of `fork/gtaxllte`** (unpushed; there is
no `origin/gtaxllte`, only `fork/`). Working tree: new staged files (`A`: the panel binding yaml and driver .c) plus unstaged
Kconfig, Makefile, DTS changes. Push the 14 existing commits with the first kernel push; they are not part of this plan.

Order matters: commit and push the kernel submodule first, then commit the gitlink bump (`src/mainline`) in the main repo
together with the topic that needs it (or as its own "bump" commit at the end).

## A. Submodule `src/mainline` (branch gtaxllte)

Files: `drivers/gpu/drm/panel/panel-samsung-gtaxllte-hx8279d.c` (new), `.../Kconfig`, `.../Makefile`,
`Documentation/devicetree/bindings/display/panel/samsung,gtaxllte-boe-hx8279d.yaml` (new),
`arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts` (169 lines added, mixed topics).

Suggested commits (DTS hunks by node; use `git add -p arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dts`, answer `y` only for
the hunks of the current topic, `n` for the rest, `s` to split a hunk when two topics share it):

1. `dt-bindings: display: panel: add Samsung gtaxllte BOE HX8279D panel`
   - `samsung,gtaxllte-boe-hx8279d.yaml`
2. `drm/panel: add Samsung gtaxllte BOE HX8279D DSI panel driver`
   - `panel-samsung-gtaxllte-hx8279d.c`, `Kconfig`, `Makefile`
3. `arm64: dts: exynos7870: gtaxllte: enable DECON, DSI and the HX8279D panel` (DSI panel)
   - hunk `cont_splash_mem:` label plus `iommu-addresses = <&decon ...>` (reserved-memory framebuffer@67000000)
   - hunk `regulator-fixed-lcd` (`vdd_fixed_lcd`, gpd3-4, always-on)
   - hunk `&decon { memory-region ...}`, `&dsi { ... panel@0 ... }`
   - `&gpu { status = "okay"; }` sits in the same hunk as `&decon`/`&dsi`. It is a Panfrost enable, not DSI: either
     split with `s`/`e` into its own commit (`... gtaxllte: enable the Mali GPU`) or accept it in the DSI commit and say so.
   - the `ldo33` hunk (`regulator-boot-on; regulator-always-on` plus the comment change on "sensors: 2.8V") belongs to
     **sensors**, not DSI.
4. `arm64: dts: exynos7870: gtaxllte: add mmc1 with pwrseq for QCA9377 WiFi` (WiFi)
   - `aliases`: `mmc1 = &mmc1;`
   - `pwrseq_mmc1`, `vdd_fixed_wlan` (cnss_dcdc_en, gpa0-6) nodes
   - `&mmc1 { ... }`
   - NOTE `vdd_fixed_wlan` is also the Bluetooth `vddio-supply`; commit it here, BT commit follows.
5. `arm64: dts: exynos7870: gtaxllte: add LIS2HH12 accelerometer and CM3323 light sensor` (sensors)
   - `&i2c7 { accelerometer@1d; light-sensor@10 }`
   - `acc_int` pinctrl (`acc-int-pins`, gpa0-7)
   - `vdd_ldo32/ldo33` hunk (sensor supply always-on + comment)
6. `arm64: dts: exynos7870: gtaxllte: add QCA9377 Bluetooth on serial1` (Bluetooth)
   - `bt_sleep_clk` fixed-clock node (it sits in the same hunk as `pwrseq_mmc1`/`vdd_fixed_wlan`: split with `s` or `e`)
   - `bt_en` pinctrl (`bt-en-pins`, gpd4-0)
   - `&serial1 { bluetooth { ... } }`

Check: all hunks sum to the 169 added lines. After the sequence `git diff` on the DTS must be empty. If hunk splitting gets
tedious, the acceptable fallback is one DTS commit `... gtaxllte: WiFi, DSI panel, sensors, Bluetooth` since nothing was
tested on HW yet and the topics are all "built, untested".

Then: `git push fork gtaxllte` (14 old + new commits). Do not push to `origin` (torvalds).

## B. Main repo `galaxy-tab-a-2016`

Commit order:

1. `U-Boot: mainline build for chainload from S-Boot (HS200/HS400 off)`
   - `uboot/build.sh`, `uboot/gtaxllte.config`, `uboot/dts/exynos7870-gtaxllte.dts`,
     `uboot/dts/exynos7870-gtaxllte-u-boot.dtsi`, `uboot/env/gtaxllte.env`
   - `.gitignore` hunk for `/src/u-boot/`, `/uboot/build/`, `/uboot/out/` (`git add -p .gitignore`; the `/lineageOS/` line goes with commit 9)
   - Do NOT add `uboot/build/`, `uboot/out/` (53 MB, ignored) or `src/u-boot/`.
2. `kernel: pmOS config fragment (EFI, systemd/BPF, zram) plus WiFi, DSI, sensors, BT options`
   - `kernel/gtaxllte-pmos.config` (new, one file; its sections are per topic: default/zram, WiFi `CFG80211`/`ATH10K`,
     DSI panel, sensors, Bluetooth). Splitting a new file by topic is possible only with `git add -N` + `git add -p`; not
     worth it, one commit is fine.
   - `kernel/gtaxllte-builtin.config` (`CONFIG_QFMT_V2=y`; arguably its own tiny commit
     `kernel: QFMT_V2 for the Lineage userdata ext4 quota`)
3. `pmOS: device-samsung-gtaxllte and linux-samsung-gtaxllte packages`
   - `pmos/device-samsung-gtaxllte/{APKBUILD,deviceinfo,kernel-cmdline.conf,61-gtaxllte-keys.hwdb,device-samsung-gtaxllte.post-install}`
   - `pmos/linux-samsung-gtaxllte/{APKBUILD,config-samsung-gtaxllte.aarch64,timeconst.bc}`
   - `config-samsung-gtaxllte.aarch64` is a 167 KB generated copy of the merged config: it is the package input, keep it,
     but regenerate it after any `gtaxllte-pmos.config` change (sha512 in the APKBUILD).
   - Possible split: Home key hwdb as `pmOS: Home key to Super via udev hwdb`.
4. `stage 1: boot image numbering, module stripping, rootfs-up/rootsh, NAT helper`
   - `kernel/build-stage1.sh`, `kernel/initramfs/init`, `kernel/initramfs/rootfs-up`, `kernel/initramfs/rootsh`,
     `kernel/tools/host-nat.sh`, `kernel/tools/rootfs/build.sh`, `kernel/tools/rootfs/write-sd.sh`
5. `apps: pads (SDL3 KMSDRM pad grid)`
   - `apps/pads/pads.c`
6. `panel power test tooling: DTB variant without always-on panel rails`
   - `kernel/tools/mk-panelpwr-dtb.sh`
   - (WiFi has no tooling of its own; sensors and BT only have docs, see 7.)
7. `docs: test plans (DSI, sensors, Bluetooth) and standard-interfaces audit`
   - `docs/dsi-test-plan-2026-10-27.md`, `docs/sensors-test-plan-2026-10-27.md`,
     `docs/bluetooth-test-plan-2026-10-27.md`, `docs/standard-interfaces-audit-2026-10-27.md`,
     `docs/commit-plan-2026-10-27.md`
8. `docs: handoffs 2026-10-25 and 2026-10-26`
   - `docs/handoff-2026-10-25.md`, `docs/handoff-2026-10-26.md`
9. `CLAUDE.md refresh: general lean tablet, U-Boot + systemd-boot + pmOS chain`
   - `CLAUDE.md`, `.gitignore` (`/lineageOS/` hunk)
10. `records: ...` (can be split into 2 or 3 by directory)
    - `docs/records/FOCUS.md`, `docs/records/INDEX.md`
    - `docs/records/device/**` (U-Boot, fastboot, power button learnings)
    - `docs/records/goal/**` (general-tablet, pmOS, standard-interfaces decisions)
    - `docs/records/mainline/**` (WiFi, DSI, BT, sensors, config learnings; includes the DELETED
      `todo_t585_pmic_reset_test_numbered_images_flash_panfrost_2026_10_24.md`, stage it with `git add -A docs/records/mainline`)
    - `docs/records/workflow/**` (pmOS install/ssh/recovery patterns)
    - `docs/records/general/user/` is ignored and must stay out.
11. `src/mainline: bump submodule to <hash> (WiFi, DSI, sensors, BT)` after the kernel push of section A.

## Must NOT be committed (all checked against `.gitignore`)

| Item | Covered by `.gitignore` |
|---|---|
| `lineageOS/` (ROM zips, personal `invoice.pdf`) | yes, `/lineageOS/` (and the old `/samsung galaxy tab a (2016)/`) |
| `device-dump/sm-t585/firmware/` (proprietary blobs) | yes |
| `device-dump/.unredacted/`, `device-dump/sm-t585/sys/devicetree-base.tar` | yes |
| `device-dump/**/*.img` | yes |
| `kernel/out/`, `kernel/build/`, `kernel/.venv/` | yes |
| `uboot/build/`, `uboot/out/`, `src/u-boot/` | yes |
| `docs/records/general/user/` | yes |
| `.claude/settings.local.json` | yes |
| ssh private key `~/.ssh/id_ed25519_gtaxllte` | outside the repo; no key file found tracked (`git ls-files` for `*.pem`, `id_ed*`, `*.key`, `*.img`, `*.bin` is empty) |

Untracked large/binary files: none outside ignored paths. The untracked set is small text/source. Largest is
`pmos/linux-samsung-gtaxllte/config-samsung-gtaxllte.aarch64` (167 KB text). `uboot/` itself is 53 MB only because of the ignored
`build/` and `out/` directories. Before committing, run `git status --short -uall | grep -v '^ M'` and make sure no
`*.img`, `*.ko`, `*.sqfs`, `*.bin` shows up (rootfs squashfs images built by `kernel/tools/rootfs/build.sh` go to the
user-chosen output dir; keep them outside the repo).

Privacy note: the new records and docs mention the ssh key *path* and `172.16.42.1` only; no key material. Quick check
before committing: `grep -rn 'BEGIN .*PRIVATE\|serial\b' docs pmos uboot` and look at hits.
