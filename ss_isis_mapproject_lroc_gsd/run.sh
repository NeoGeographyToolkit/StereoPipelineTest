#!/bin/bash

set -x verbose
rm -rfv run

# Auto-determine GSD

mapproject ../data/hermite_a_dem_mosaic_crop.tif ../data/M124818512RE.cal.echo_crop.cub run/run-ortho.tif --tile-size 64


