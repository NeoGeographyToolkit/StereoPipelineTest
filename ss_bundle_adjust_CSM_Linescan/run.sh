#!/bin/bash

set -x verbose
rm -rfv run

bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub ../data/B17_016219_1978_XN_17N282W.8bit.json ../data/B18_016575_1978_XN_17N282W.8bit.json -o run/run

# Run bundle adjustment with a weight image
bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json --match-files-prefix run/run --weight-image ../data/ctx_image_weight.tif -o run/run-weight --tri-weight 100 --tri-robust-threshold 0.5 --camera-weight 0 --num-iterations 10 --force-reuse-match-files

# Re-run bundle adjustment with the model state files saved by the previous run
bundle_adjust --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json -o run/run --force-reuse-match-files

# Solve for jitter. This needs the match files found in the first bundle_adjust call.
jitter_solve --threads 1 ../data/B17_016219_1978_XN_17N282W.8bit.cub ../data/B18_016575_1978_XN_17N282W.8bit.cub run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json -o run/jitter --match-files-prefix run/run --num-iterations 5

