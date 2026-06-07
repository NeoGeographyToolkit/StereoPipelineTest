#!/bin/bash

# CLOUD-MAC TEST: one of the small subset of tests that also run on Mac ARM64 and
# Linux ARM in the cloud (GitHub Actions, see .github/workflows in StereoPipeline).
# This subset is bundled into the StereoPipelineTest.tar release asset (tag 0.0.1).
# If that small tarball is ever lost, the cloud Mac/ARM suite can be rebuilt by
# collecting every test in this repo that carries this CLOUD-MAC TEST marker.

set -x verbose
rm -rfv run

pc_align ../data/13APR25_WV02_SEVZ_1030010021A8A100_10030010021A64500_DEM3-3m_10pct.tif ../data/Severnaya-Bedrock-UTM47-Ellipsoidal-Height.txt --csv-format "utm:47N 1:easting 2:northing 3:height_above_datum" --max-displacement 100 --save-transformed-source-points --save-inv-transformed-reference-points --max-num-reference-points 1000000 --max-num-source-points 100000 -o run/run
#Severnaya_UTM47_llh.txt

# Test for point2las
point2las run/run-trans_reference.tif
point2las gold/run-trans_reference.tif

