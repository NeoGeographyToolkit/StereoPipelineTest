#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
uname -n > run/machines.txt

# Test for when the DEM grid and output image grid are the same. This demonstrates a bug fix
# for erision in the output mapprojected image at DEM boundary.
mapproject --tr 10 --tile-size 50 ../data/dem_tr10.tif ../data/sfs-cam.cub run/run.tif --nodes-list run/machines.txt --threads 1

