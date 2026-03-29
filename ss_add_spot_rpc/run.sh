#!/bin/bash

# Test add_spot_rpc: generate RPC from exact SPOT5 model, then compare
# the RPC against the exact model with cam_test.

set -x verbose
rm -rfv run

mkdir run

# Generate RPC model. Writes the RPC to the output .dim file.
cp ../data/spot5_front_crop.dim run/spot5_front_crop_rpc.dim
add_spot_rpc run/spot5_front_crop_rpc.dim

# Compare exact (spot5) vs RPC. Height 0 since this is Antarctica.
cam_test --session1 spot5 --session2 rpc \
  --image ../data/spot5_front_crop.bil \
  --cam1 ../data/spot5_front_crop.dim \
  --cam2 run/spot5_front_crop_rpc.dim \
  --height-above-datum 0 \
  --sample-rate 500 \
  | grep -E "Min|Max|Median" > run/run-out.txt
