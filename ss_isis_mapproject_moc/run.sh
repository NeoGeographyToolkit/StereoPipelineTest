#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

cp -f $d/M0100115.cub input.cub
spiceinit from=input.cub       

rpc_mapproject --mpp 40 $d/ref-ortho-moc-DEM.tif input.cub run/run-ortho.tif



