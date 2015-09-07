#!/bin/bash

set -x verbose
rm -rfv run

mapproject ../data/sfs-DEM.tif ../data/sfs-cam.cub run/run.tif --tile-size 50

