# DECON/DSIM first-enable hard hang: analysis (2026-10-27, read-only, nothing run)

Paths: DEC = `src/mainline/drivers/gpu/drm/exynos/exynos7_drm_decon.c`,
DSI = `src/mainline/drivers/gpu/drm/bridge/samsung-dsim.c`,
CMU = `src/mainline/drivers/clk/samsung/clk-exynos7870.c`.

## What the enable path does (order matters)

atomic commit -> `drm_atomic_helper_commit_modeset_enables`: CRTC first, bridges after.

1. `decon_atomic_enable` (DEC:542): `pm_runtime_resume_and_get` (clocks are all CRITICAL gates, so
   nothing really changes) -> `decon_init` (DEC:525): `VIDCON0_SWRESET` written, **no wait for the
   reset to finish**, then VIDOUTCON0/VCLKCON0/VIDCON1 written -> `decon_commit`: porches,
   `VIDCON0_ENVID|ENVID_F` (DEC:251), `VCLKCON1/2` only if `clkdiv>1` (DEC:256).
   Then `decon_update_plane` (DEC:399): window DMA address = **0xbb000000** (physical, see H1).
2. DSIM `samsung_dsim_atomic_pre_enable` (DSI:1642): runtime resume (DSI:2264): dummy regulators,
   4 clocks, `phy_power_on` (PMU enable + DISP sysreg 0x148f100c bit0 = DPHY resetn; both already 1
   if the bootloader left the link up).
3. Panel `prepare` (prepare_prev_first) -> first DSI transfer -> `samsung_dsim_init` (DSI:1618):
   SWRST, `enable_clock` -> `set_pll` (DSI:786): writes PLLCTRL (DSI:852) and **polls LINK_STATUS bit 24**
   (3000 iterations, no sleep), then PHY timing regs, `init_link` (FIFOCTRL, CONFIG, lanes, polls
   DPHY_STATUS, DSI:1045), then ~260 LPM commands.

Important: the bootloader leaves DECON + DSIM + DPHY PLL + panel running (simpledrm shows its picture).
So mainline does not bring a cold block up, it **takes over a running pipeline**: SWRESET of DECON
and SWRST/PLL re-programming of DSIM happen while the stream is live. Downstream avoids exactly this
(`dsim_reg_init`/`dsim_reg_set_clocks` return early when TX_REQUEST_HSCLK / PLL_STABLE are already set,
"LCD_ON_UBOOT"; `decon_reg_reset` polls the SWRESET bit, decon_reg_7870.c:19).

Things that are NOT the problem (checked):
- No power domain for DISPAUD in `exynos7870.dtsi` (no `power-domains`, no `pd_` nodes): nothing can
  power-gate DECON/DSIM; the block stays as the bootloader left it.
- No rate change anywhere in the path. `decon0_vclk`/`eclk` are the `MUX_DECON_*` gates
  (exynos7870.dtsi `decon:` clocks, CMU:1259 ff), only `clk_get_rate` is called (DEC:192); DSIM has no
  `pll_clk` (the "pll" bulk clock is the APB gate, `dsi->pll_clk` is never set, `fin` = DT 26 MHz),
  so DSIM does no `clk_set_rate` either. Re-parenting/DISP_PLL change/audio-bus stall is unlikely
  (the audio I2S shares only critical, always-on gates). Mainline never programs DISP_PLL
  (downstream: disp-pll 159 MHz, eclk 200, vclk 159) and relies on the bootloader value.
- PMS: for 980 MHz the loop (DSI:730) picks p=3 m=113 s=0 (VCO 979 MHz) because the strict `<` keeps
  the first of two equal candidates; downstream/bootloader use p=3 m=226 s=1 (VCO 1958 MHz). Mainline
  cannot produce m=226 (`m_max=125`, `max_freq=1500`, DSI:636-640). Other upstream boards run
  the same code with VCO < 1 GHz (a2corelte 836 MHz -> p3 m96 s0; on7xelte 1001 MHz), so a VCO of 979 MHz is
  probably legal, but see H2.
- PHY timings are hard-coded for one frequency: `exynos7870_reg_values` (DSI:428) and the three
  `PHYTIMING_*` entries in `reg_ofs` (DSI:340ff) are fixed values (`has_freqband`=0 so
  `samsung_dsim_set_phy_ctrl` computes them from `hs_clock` via `phy_mipi_dphy_get_default_config_for_hsclk`
  instead, DSI:923). Downstream uses a table keyed on hs/esc clock. Wrong timings would give a dark/garbled
  panel, not a bus hang.

## Ranked hypotheses

### H1 (most likely): DECON DMA runs through a SysMMU nobody manages
Evidence:
- `# CONFIG_EXYNOS_IOMMU is not set` (`kernel/build/.config:4259`, `pmos/.../config-samsung-gtaxllte.aarch64:4259`,
  also absent from `kernel/gtaxllte-*.config`). The trim removed it; `sysmmu_decon` (exynos7870.dtsi:866) has no driver.
- The fbdev buffer is `dma_addr 0xbb000000`: a physical CMA address, so `exynos_drm_register_dma`
  found no IOMMU domain (`exynos_drm_dma.c:113`), and DECON is told to DMA straight from DRAM.
- The DTS carries `iommu-addresses = <&decon 0x67000000 ...>` for the splash: the bootloader runs DECON
  **through** SysMMU_DECON (identity map of the splash only). Without the driver the SysMMU keeps the
  bootloader state (enabled, page table = splash only). A DECON read of 0xbb000000 then faults in the
  SysMMU, the master stalls with outstanding AXI transactions. Together with a `SWRESET` of DECON that
  does not wait/quiesce (DEC:529), a DISP NoC / AXI lock-up is plausible, and then the next CPU access
  into the DISP block (DSIM or DECON SFR, vsync IRQ handler) never completes: one CPU stuck in a load with
  IRQs on CPU0 = total silence, ssh dead, only PMIC reset helps.
- Counter: not proven that the SysMMU is on; if the bootloader left it in bypass this hypothesis is dead.

Experiment E1 (no rebuild, 1 hard reset at most). All reads are on clocked, always-on blocks, safe.
```
# busybox devmem; run BEFORE modprobe, with the DSI-on DTB
devmem 0x14860000 32   # CTRL   (0x5 = enabled, 0 = disabled/bypass)
devmem 0x14860004 32   # CFG
devmem 0x14860008 32   # STATUS
devmem 0x14860034 32   # VERSION
devmem 0x1486000c 32   # PT base (v5), tells if a bootloader table is installed
# DECON state left by the bootloader / after bind
for o in 0x00 0x04 0x10 0x14 0x40 0x50 0x54 0x880 0x890; do printf "%s " $o; devmem $((0x14830000+o)) 32; done
```
If CTRL==5: `devmem 0x14860000 32 0` (disable, bypass; phys==virt, so the splash keeps scanning), then
`modprobe panel_samsung_gtaxllte_hx8279d`. If it now survives, H1 is confirmed. Permanent fix:
`CONFIG_EXYNOS_IOMMU=y` (built-in, in `kernel/gtaxllte-builtin.config`), config-only rebuild; then the
DRM allocator uses IOVA and the SysMMU reserved region from `iommu-addresses` keeps the splash alive.
Cheap alternative with the same effect for a test: keep `EXYNOS_IOMMU` off and remove `iommus = <&sysmmu_decon>`
(irrelevant without a driver, so the devmem disable is the real test).

### H2: DSIM PLL / PHY re-programmed under a live link, SFR poll hangs when the PHY byte clock vanishes
Evidence:
- DSI byte and esc clocks are the CMU "user" muxes `MUX_MIPIPHY_TXBYTECLKHS_USER` / `RXCLKESC0_USER`
  (CMU:1228-1251), which select the **PHY-generated** clock (bit 12 set by the critical `_USER_CON` gate).
  They are modelled as fixed 188 MHz rates (CMU:1100ff), but the real clock only exists while the DPHY PLL runs.
- `samsung_dsim_set_pll` rewrites PMS (3,226,1 -> 3,113,0) while PLL_EN is still 1 (DSI:852): the PLL
  unlocks, the byte clock stops, and the next `samsung_dsim_read(LINK_STATUS)` (DSI:855-865) hangs if the
  DSIM SFR read needs the byte clock (same dependency is why exynos5433 lists the phyclk gates in
  `exynos5433_clk_bulk_data`). A tight 3000-iteration poll with no `udelay` is also the first thing that runs
  after the PHY changed state.
- Not set by mainline: `DSIM_PLL_CTRL1/2` (0x98 = 0x40000000, 0x9c = 0) that downstream writes
  (`DSIM_M_PLL_CTRL1`, dsim_reg_7870.c:44); the bootloader value survives unless the PHY was reset.
- Counter: a2corelte/j6lte/on7xelte run the same code upstream; cold-started by their bootloader too, so the
  "live link" difference is the novelty here, and hardware-wise the same.

Experiments:
- E2a (no rebuild): read DSIM state before modprobe, last in the session (may itself hang = result: SFR
  access needs the PHY clock): `devmem 0x14800004` (bit 24 PLL stable), `0x14800010` (CLKCTRL, bit 20
  TX_REQUEST_HSCLK), `0x14800094` (PLLCTRL: PMS), `0x14800098`, `0x1480009c`, `0x14800030` (CONFIG), `0x148000a4`, `0x148000b4`.
  Expected from the bootloader: bit24=1, PMS = p3 m226 s1.
- E2b (DTB only): force the PMS the bootloader already uses by making mainline pick it. Not possible with
  `burst-clock` alone (s=0 wins, m_max=125), so use the known-good board value:
  `fdtput -t u <dtb> <dsi node> samsung,burst-clock-frequency 1001000000` (on7xelte; the code picks p4 m154 s0, VCO 1001 MHz, exact;
  VCO is higher than 979 MHz). If the hang moves or vanishes, PMS/VCO is implicated. Find the node with
  `fdtget -l <dtb> /soc@0` first.
- E2c (rebuild, 2-line patch): in `samsung_dsim_pll_find_pms` prefer larger `s` on ties (`<=`) and raise
  `m_max` to 255, `max_freq` to 2000 for 7870: gives exactly the bootloader PMS (3,226,1) so the PLL does not
  glitch at all (register value identical, but hardware sees no change). Also add the early-return of downstream
  (`if PLL already stable and TX_REQUEST_HSCLK: skip PLL/reset`) for a pure takeover test.

### H3: DECON enable sequence differs from downstream (reset not awaited, CRTC before DSIM)
- `VIDCON0_SWRESET` (DEC:529) is followed immediately by more SFR writes; downstream polls until the bit
  clears (decon_reg_7870.c:19-35, up to 20 ms). Writes into a block still in reset on a live video path are a
  classic bus-hang source.
- `ENVID|ENVID_F` is set in the CRTC enable (DEC:251), i.e. **before** the DSIM bridge pre_enable and the panel
  prepare; downstream starts DECON last (`decon_reg_start`, decon_reg_7870.c:418) after DSIM/panel are up.
  With DSIM then SWRST + PLL-reprogrammed while DECON pushes pixels, the DSIM main-image FIFO is fed
  by a pixel stream while the DSIM is in reset.
- Missing vs downstream: `WINCHMAP0` default channel mapping (decon_reg_7870.c:38), `BLENDCON`
  (8-bit alpha), `VCLKCON1/2` written with a divider derived from the *clk framework* rate (DEC:192-258)
  although downstream never writes a divider (the CMU gives 159 MHz): if the framework's idea of the
  `MUX_DECON_VCLK` rate differs from hardware, DECON gets a wrong internal divider.

Experiments:
- E3a (no rebuild): read the clock tree the framework believes in (safe on mainline, it reads only
  cached rates, unlike the downstream clk_summary): `cat /sys/kernel/debug/clk/clk_summary | grep -iE 'dispaud|decon|mipi'`.
  `decon0_vclk` rate: if > 159.6 MHz then `clkdiv>1` and VCLKCON1/2 get written (DEC:256). Also
  `devmem 0x148d0200/0210/0214/0218/021c/0220/0224/0228/0404/0408` (CMU_DISPAUD muxes/dividers) and
  `devmem 0x148d0100` (DISP PLL CON0) to see what the bootloader selected.
- E3b (rebuild): add the poll to DECON reset, skip `VCLKCON1/2`, and start `ENVID` only from
  `atomic_enable` of the bridge (or just `decon_reg_start` after panel prepare).

### Lower-ranked
- H4 panel/LPM: 260 DSI commands in LPM while the BL link is in HS video; failure mode is transfer
  timeout (`wait_for_completion`), not a hang. Quick check: dmesg for `timeout` before the freeze.
- H5 DSIM/DECON IRQ storm with an unmasked source; handlers only touch SFRs, would show `irq ... nobody cared`.
- H6 the 10 s delay: nothing in code waits 10 s; it is the fbdev initial-config worker, i.e. timing of
  the first commit, not a clue.

## Getting the last step without a serial port

PMIC reset wipes DRAM, so ramoops cannot help, and a hang of the CPU that owns the USB IRQ kills the live
`dmesg -w`. Options, cheapest first:
1. `dmesg -w` over ssh with `drm.debug=0x1f` and `ignore_loglevel`: the last line is the last *printed*
   step before the stuck CPU stopped servicing the NCM IRQ; steps themselves are not logged by default
   (only `[CRTC] enabling`, `start addr` from DEC debug prints), so add prints.
2. Rebuild with `dev_info("MARK n")` at: DEC:547 (before/after pm_runtime), after `decon_init` (DEC:525),
   after `decon_commit`, in `decon_update_plane` after the `VIDW_BUF_START` write (DEC:~420) and after
   `WINCONx_ENWIN` (DEC:484); DSI:1651 (pre_enable), DSI:2276 (clk enable), DSI:2280 (phy_power_on),
   DSI:852 (before PLLCTRL write), DSI:855 (after, with the `LINK_STATUS` value in the loop on first iteration),
   DSI:1618 steps (reset / enable_clock / set_phy_ctrl / init_link), panel `gtaxl_prepare`.
   Add `mdelay(50)` after each so the NCM TX gets to run.
3. Screen markers (survive a hang because the bootloader DECON keeps scanning the splash buffer, if it is
   still enabled): `ioremap_wc(0x67000000, ...)` once and `memset_io` a white bar of 20 lines at line n*40 after
   marker n; photograph the panel after the freeze. (If H1 is true the splash window itself may be the thing that dies,
   then use 2.)

## Order of experiments (each <= 1 hard reset)

1. Read-only dumps (SysMMU 0x14860000, DECON, CMU_DISPAUD, clk_summary): no hang risk, tells H1/H3 state.
2. E1: disable SysMMU_DECON via devmem, then modprobe. (H1)
3. E2a read DSIM SFRs (risk: hang = answer for H2), then E2b DTB with a different burst clock.
4. Rebuild batch: `CONFIG_EXYNOS_IOMMU=y` + marker prints + DECON reset poll + PMS-tie tweak, as separate bisectable
   changes (config first).
