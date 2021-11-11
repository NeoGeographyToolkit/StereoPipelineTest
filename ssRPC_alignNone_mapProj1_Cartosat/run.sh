#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/cartosatA.tif ../data/cartosatF.tif run/run ../data/cartosat-DEM.tif

# Test point2dem with a string using EPSG
point2dem --t_srs 'EPSG:4326' --orthoimage run/run-PC.tif run/run-L.tif

