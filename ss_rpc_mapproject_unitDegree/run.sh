#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

rpc_mapproject --mpp 10 $d/ref-DEM-unitDeg.tif $d/WV01_11JAN131652275-P1BS-10200100104A0300.tif $d/WV01_11JAN131652275-P1BS-10200100104A0300.xml run/run-RPC.tif -t dg

