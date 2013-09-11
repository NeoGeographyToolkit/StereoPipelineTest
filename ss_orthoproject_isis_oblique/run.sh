#!/bin/bash

set -x verbose
rm -rfv run

cp -f ../data/AS15-M-1336.lev1.cub input.cub
spiceinit from=input.cub       
orthoproject --mpp 200 ../data/AS15-1336-1337-DEM.tif input.cub run/run-ortho.tif



