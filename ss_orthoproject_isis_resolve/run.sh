#!/bin/bash

set -x verbose
rm -rfv run

cp -f ../data/ref-resolve.cub input.cub
spiceinit from=input.cub       

orthoproject --mpp 20 ../data/ref-ortho-resolve-DEM.tif input.cub run/run-ortho.tif



