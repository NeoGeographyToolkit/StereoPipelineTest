#!/bin/bash

set -x verbose
rm -rfv run

stereo ../data/cartosatA.tif ../data/cartosatF.tif run/run ../data/cartosat-DEM.tif
point2dem --orthoimage run/run-PC.tif run/run-L.tif


