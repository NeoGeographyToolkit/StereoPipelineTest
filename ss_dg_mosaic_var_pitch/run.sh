#!/bin/bash

# In this testcase the various xml files have different pitches. We put a bugfix for that.

set -x verbose
rm -rfv run

dg_mosaic --verbose ../data/WV02_10JUN212134084-P1BS-1030010006271A00.r5.tif  ../data/WV02_10JUN212134088-P1BS-1030010006271A00.r5.tif  ../data/WV02_10JUN212134096-P1BS-1030010006271A00.r5.tif  ../data/WV02_10JUN212134100-P1BS-1030010006271A00.r5.tif --skip-rpc-gen --output-prefix run/run --reduce-percent 50 --preview --fix-seams


