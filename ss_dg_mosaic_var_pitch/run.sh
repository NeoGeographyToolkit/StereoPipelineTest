#!/bin/bash

# In this testcase the various xml files have different pitches. We put a bugfix for that.

set -x verbose
d=../data
dir=run
rm -rfv $dir

dg_mosaic --verbose $d/WV02_10JUN212134084-P1BS-1030010006271A00.r5.tif  $d/WV02_10JUN212134088-P1BS-1030010006271A00.r5.tif  $d/WV02_10JUN212134096-P1BS-1030010006271A00.r5.tif  $d/WV02_10JUN212134100-P1BS-1030010006271A00.r5.tif --skip-rpc-gen --output-prefix run/run --reduce-percent 50 --preview


