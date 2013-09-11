#!/bin/bash

set -x verbose
rm -rfv run

cp -f ../data/M0100115.cub input.cub
spiceinit from=input.cub       

orthoproject --mpp 40 ../data/ref-ortho-moc-DEM.tif input.cub run/run-ortho.tif



