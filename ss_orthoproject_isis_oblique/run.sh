#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

cp -f $d/AS15-M-1336.lev1.cub input.cub
spiceinit from=input.cub       
orthoproject --mpp 100 $d/AS15-1336-1337-DEM.tif input.cub run/run-ortho.tif



