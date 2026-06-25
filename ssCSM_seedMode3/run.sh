#!/bin/bash

# CLOUD-MAC TEST: one of the small subset of tests that also run on Mac ARM64 and
# Linux ARM in the cloud (GitHub Actions, see .github/workflows in StereoPipeline).
# This subset is bundled into the StereoPipelineTest.tar release asset (tag 0.0.1).
# If that small tarball is ever lost, the cloud Mac/ARM suite can be rebuilt by
# collecting every test in this repo that carries this CLOUD-MAC TEST marker.

set -x verbose
rm -rfv run

# Stereo with CSM cameras and corr-seed-mode 3, which builds the low-resolution
# seed disparity with sparse_disp. This exercises that sparse_disp and the Python
# modules it needs (numpy, scipy, gdal) ship and work in ASP. Reuses the same CSM
# data as ssCSM_Linescan.
stereo --left-image-crop-win 2057 10449 364 328 --right-image-crop-win 2695 10691 485 358 --corr-seed-mode 3 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json run/run --ip-detect-method 2
point2dem -r mars run/run-PC.tif --nodata-value -32767
