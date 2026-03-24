#!/bin/bash

set -x verbose
rm -rfv run

mkdir run

# SPOT 6 exact linescan model vs RPC. Uses ESA La Crau sample (PAN band).
# The exact model uses session "spot", the RPC uses session "rpc".
# A small 100x100 crop is used just for image dimensions.

cam_test --session1 spot --session2 rpc \
  --image ../data/SPOT6_P_crop.tif \
  --cam1 ../data/DIM_SPOT6_P_202404211020526_SEN_6979210101.XML \
  --cam2 ../data/RPC_SPOT6_P_202404211020526_SEN_6979210101.XML \
  --height-above-datum 200 \
  --sample-rate 50 \
  | grep -E "Min|Max|Median" > run/run-out.txt
