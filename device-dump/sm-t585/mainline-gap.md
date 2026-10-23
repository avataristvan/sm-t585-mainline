# SM-T585 (gtaxllte) — mainline gap analysis (2026-10-23)

Sources: live DT + dmesg from device (this dir), downstream `src/downstream-lineage-21`
(Exynos7870-labs, branch lineage-21, running commit e2426d3c1cef), mainline `src/mainline`
(torvalds 734bef548, v7.3+ merge window). Raw compatible-string diff: `mainline-compare.txt`
(naive — downstream and mainline name the same blocks differently).

## SoC (exynos7870.dtsi in mainline)

| Block | Mainline |
|---|---|
| CPU, GIC, timer, PSCI, pinctrl, chipid, PMU | yes |
| CMUs (peri, fsys, mif, dispaud, g3d, isp, mfcmscl) | yes |
| UART, I2C, HSI2C | yes |
| DW-MMC (eMMC/SD/SDIO) | yes |
| USB DRD (dwc3 + phy) | yes |
| DECON + MIPI-DSI + DSI phy | yes |
| Mali-T830 (`samsung,exynos7870-mali`, panfrost) | yes |
| SysMMU | yes |
| Audio (I2S/LPASS/ABOX) | **no** |
| TMU (thermal), cpufreq, devfreq | **no** |
| ADC | **no** |
| MFC, scaler, JPEG | **no** (not in dtsi) |
| Camera (FIMC-IS, CSIS) | **no** |

## Board chips

| Function | Chip (downstream) | Mainline driver | Status |
|---|---|---|---|
| PMIC | S2MPU05 @hsi2c 0x66 | mfd/sec-* | ok |
| Display | HX8279D, 1200x1920 DSI (id 827903) | panel-himax-hx8279 | driver exists, needs new panel variant (init seq from downstream `decon_7870/panels/hx8279d_*`) |
| Touch | STM FTS1A096 @i2c7 0x49 | stmfts | same command set (0x84/0x85/0x86) — likely compatible, untested |
| WiFi | QCA9377 SDIO (0271:0701) | ath10k_sdio | driver supports ID; needs ath10k-format firmware (device has qcacld `qwlan30.bin`) |
| Bluetooth | QCA (DT says qca6174) UART | hci_qca | check exact chip |
| Audio codec | RT5659 @i2c5 0x1b | snd-soc-rt5659 | codec ok, SoC audio side missing |
| Charger/MFD | SM5703 | **regulator binding only**, no charger/fuelgauge driver | missing |
| Fuel gauge | SM5703 FG @0x71 | — | missing |
| MUIC | SM5703 @0x25 | extcon-sm5502 mentions sm5703 | check |
| Accel | K2HH (= LIS2HH12) | st_accel | ok |
| Light | CM3323 | iio cm3323 | ok |
| Grip | 2x SX9306 | sx9310 handles sx9310/11 only | missing |
| Cameras | S5K4H5YC, SR259, DW9807 | — | missing (FIMC-IS) |
| Keys, hall | gpio-keys | gpio-keys | ok |

## Takeaway

A headless/basic boot (eMMC, SD, USB, display via simple-framebuffer → DSI panel, touch,
WiFi) is reachable with a new `exynos7870-gtaxllte.dts` plus one panel variant. Real driver
work: SM5703 charger/fuel gauge, SoC audio, thermal/cpufreq. Camera is out of scope.
