#!/bin/bash

# CLOUD-MAC TEST: one of the small subset of tests that also run on Mac ARM64 and
# Linux ARM in the cloud (GitHub Actions, see .github/workflows in StereoPipeline).
# This subset is bundled into the StereoPipelineTest.tar release asset (tag 0.0.1).
# If that small tarball is ever lost, the cloud Mac/ARM suite can be rebuilt by
# collecting every test in this repo that carries this CLOUD-MAC TEST marker.

set -x verbose
rm -rfv run

bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json -o run/run

# Run bundle adjustment with a weight image
bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json --match-files-prefix run/run --weight-image ../data/ctx_image_weight.tif -o run/run-weight --tri-weight 100 --tri-robust-threshold 0.5 --camera-weight 0 --num-iterations 10 --force-reuse-match-files

# Re-run bundle adjustment with the model state files saved by the previous run
bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json -o run/run-reuse --force-reuse-match-files --match-files-prefix run/run

