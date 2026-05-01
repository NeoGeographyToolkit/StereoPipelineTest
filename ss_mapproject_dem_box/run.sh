#!/bin/bash

# Test that the mapproject output extent agrees with the DEM extent when the
# camera image fully contains the DEM footprint and the output grid size and
# half-pixel convention match the DEM. Specifically:
#   (a) the output projection inherits from the DEM (no --t_srs),
#   (b) --tr equals the DEM resolution, and
#   (c) the DEM's pixel centers sit on multiples of --tr (so the DEM grid
#       and ASP's "centers at multiples of tr" output convention coincide).
# Under those conditions the output Size, Origin, and Pixel Size must match
# the DEM exactly. A bbox snap that amplifies float noise into a full-pixel
# padding makes the output grow by one pixel on each side.

set -x verbose
rm -rfv run

mkdir -p run

mapproject_single --tr 25 ../data/dem_grid_aligned.tif ../data/sfs-cam.cub \
  run/run.tif --threads 1
