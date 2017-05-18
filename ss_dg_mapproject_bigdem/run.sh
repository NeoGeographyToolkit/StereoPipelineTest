#!/bin/bash

set -x verbose
rm -rfv run

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
mapproject --mpp 30 --t_srs "$opt" ../data/krigged_dem_nsidc_ndv0_fill_crop2.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml run/run-DG.tif -t dg

