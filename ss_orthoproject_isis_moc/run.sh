#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

cp -f $d/M0100115.cub input.cub
spiceinit from=input.cub       

# bug with mpp 10!!!
#orthoproject --mpp 10 $d/ref-ortho-moc-DEM.tif input.cub run/run-ortho.tif
orthoproject --mpp 100 $d/ref-ortho-moc-DEM.tif input.cub run/run-ortho.tif



