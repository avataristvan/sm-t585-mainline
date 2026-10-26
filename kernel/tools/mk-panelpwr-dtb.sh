#!/bin/sh
# Test DTB variant with switchable panel power: drops regulator-always-on from the
# two panel supplies (vdd_fixed_lcd, LDO35/LCD_1P8) so the panel driver can really
# cut them. regulator-boot-on is kept on purpose: for the fixed regulator it makes
# the GPIO come up high at probe (dropping it would switch the panel off at boot,
# before the module loads); the core's late cleanup (30 s after init) switches the
# rails off only if the panel driver has not claimed them by then.
# Rerun after every DTB rebuild.
set -e
HERE=$(cd "$(dirname "$0")/.." && pwd)
IN=${1:-$HERE/build/arch/arm64/boot/dts/exynos/exynos7870-gtaxllte.dtb}
OUT=${2:-$HERE/out/exynos7870-gtaxllte-panelpwr.dtb}
LDO35=/soc@0/i2c@10510000/pmic@66/regulators/ldo35
FIXED=/regulator-fixed-lcd

[ "$(fdtget "$IN" "$FIXED" regulator-name)" = vdd_fixed_lcd ] || { echo "$FIXED is not vdd_fixed_lcd" >&2; exit 1; }
[ "$(fdtget "$IN" "$LDO35" regulator-name)" = vdd_ldo35 ] || { echo "$LDO35 is not vdd_ldo35" >&2; exit 1; }

cp "$IN" "$OUT"
fdtput -d "$OUT" "$FIXED" regulator-always-on
fdtput -d "$OUT" "$LDO35" regulator-always-on
echo "wrote $OUT"
