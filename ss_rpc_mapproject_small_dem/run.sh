#!/bin/bash

set -x verbose
rm -rfv run

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

# mapproject can do multiple output types
for ot in Byte UInt16 Int16 UInt32 Int32 Float32; do 
	mapproject -t rpc --mpp 25 --t_srs "$opt" ../data/krigged_dem_nsidc_ndv0_fill_crop.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml run/run-RPC_${ot}.tif --ot $ot
done


