#!/bin/bash

# In this testcase the various xml files have different pitches. We put a bugfix for that.

set -x verbose
d=../data
dir=run
rm -rfv $dir

dg_mosaic $d/WV02_10JUN212134084_5pct.tif $d/WV02_10JUN212134096_5pct.tif $d/WV02_10JUN212134088_5pct.tif $d/WV02_10JUN212134100_5pct.tif --skip-rpc-gen --output-prefix run/run --reduce-percent 50 --preview


