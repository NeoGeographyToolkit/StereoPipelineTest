#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
mapproject -t rpc --tr 10 --t_srs "$opt" $d/krigged_dem_nsidc_ndv0_fill.tif $d/WV01_11JAN131652222-P1BS-10200100104A0300.tif $d/WV01_11JAN131652222-P1BS-10200100104A0300.xml run/run-RPC.tif
