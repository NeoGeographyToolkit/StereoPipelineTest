#!/bin/bash

set -x verbose
d=../data
dir=run
rm -rfv $dir

cp -f $d/ref-resolve.cub input.cub
spiceinit from=input.cub       

orthoproject --mpp 20 $d/ref-ortho-resolve-DEM.tif input.cub run/run-ortho.tif



