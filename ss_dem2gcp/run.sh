#!/bin/bash

set -x verbose
rm -rfv run

dem2gcp                                                      \
  --warped-dem ../data/dem2gcp/run-DEM_crop_tr20.tif         \
  --ref-dem ../data/dem2gcp/ref_tr20.tif                     \
  --warped-to-ref-disparity ../data/dem2gcp/run-F.tif        \
  --left-image ../data/dem2gcp/13001_sub16.tif               \
  --right-image ../data/dem2gcp/14001_sub16.tif              \
  --left-camera ../data/dem2gcp/13001_rpc_deg3_sub16.tsai    \
  --right-camera ../data/dem2gcp/14001_rpc_deg3_sub16.tsai   \
  --match-file ../data/dem2gcp/13001_sub16__14001_sub16.match\
  --search-len 5                                             \
  --gcp-sigma 1e-2                                           \
  --output-gcp run/run.gcp

