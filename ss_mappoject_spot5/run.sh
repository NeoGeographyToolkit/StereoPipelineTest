#!/bin/bash

set -x verbose
rm -rfv run

mkdir run
cp ../data/SPOT5_METADATA.DIM  run/METADATA_RPC.DIM
add_spot_rpc run/METADATA_RPC.DIM -o run/METADATA_RPC.DIM --min-height -2000 --max-height 4000

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
mapproject --mpp 10 --t_srs "$opt" ../data/spot5_low_res_dem.tif ../data/SPOT5_IMAGE.BIL run/METADATA_RPC.DIM run/run-map.tif -t rpc --t_projwin -1187000 119000 -1161000 100000

