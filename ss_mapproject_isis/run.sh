#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run
uname -n > run/machines.txt

mapproject ../data/sfs-DEM.tif ../data/sfs-cam.cub run/run.tif --tile-size 50 --nodes-list run/machines.txt

