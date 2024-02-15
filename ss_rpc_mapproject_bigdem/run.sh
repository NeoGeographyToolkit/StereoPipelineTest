#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Test mapprojecting when the DEM extent is way bigger than image extent

uname -n > run/nodes.txt
uname -n >> run/nodes.txt

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
mapproject -t rpc --mpp 3 --t_projwin -1580730 -676190 -1577360 -679420 --t_srs "$opt" ../data/krigged_dem_nsidc_ndv0_fill.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml run/run-RPC.tif --nodes-list run/nodes.txt

