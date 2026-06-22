#!/bin/bash

# Test parallel_stereo --mapproj-geolocation-uncertainty. The two mapprojected
# CaSSIS framelets barely overlap because the mapprojection DEM is offset from
# the camera frame, which slides the left and right orthos apart. The new option
# grows the overlap mask so interest point matching and correlation do not fail.
# cassis_dem.tif is a small crop of a CaSSIS stereo DEM, offset by -600 m to
# synthesize the low-overlap case. Without the option, stereo finds no matches.
#
# Provenance of the inputs (CaSSIS push-frame observation MY36_016378, Mars,
# acquired 2021-07-25):
#   cassis_L = cas_cal_sc_20210725T202822-20210725T202826-16378-10-PAN-838849161-10-0__4_0
#              (left look, push-frame sequence id 838849161, framelet 10)
#   cassis_R = cas_cal_sc_20210725T202911-20210725T202915-16378-10-PAN-838849162-3-0__4_0
#              (right look, push-frame sequence id 838849162, framelet 3)
# cassis_dem.tif was built by CaSSIS push-frame stereo from these framelets and
# blurred (dem_mosaic --dem-blur-sigma 20), then cropped and offset -600 m here.

set -x verbose
rm -rfv run
mkdir -p run

# Mapproject both framelets onto the offset DEM, with one pinned grid size so the
# two orthos share the same GSD (required for mapprojected stereo). The DEM path
# here must match the one passed to parallel_stereo below, or stereo errors out.
mapproject --tr 4.59 --threads 1 ../data/cassis_dem.tif ../data/cassis_L.cub \
  ../data/cassis_L.json run/L.map.tif
mapproject --tr 4.59 --threads 1 ../data/cassis_dem.tif ../data/cassis_R.cub \
  ../data/cassis_R.json run/R.map.tif

parallel_stereo --alignment-method none --stereo-algorithm asp_mgm --subpixel-mode 9 \
  --mapproj-geolocation-uncertainty 70 --rm-cleanup-passes 0 --erode-max-size 0 \
  --threads 1 \
  run/L.map.tif run/R.map.tif ../data/cassis_L.json ../data/cassis_R.json run/run \
  ../data/cassis_dem.tif

point2dem run/run-PC.tif --errorimage --orthoimage run/run-L.tif
