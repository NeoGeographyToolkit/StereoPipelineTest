#!/bin/bash

set -x verbose
rm -rfv run

mkdir -p run

# Bug fix for back-of-body occlusion in mapproject. Without the fix,
# JunoCam Ganymede observations projected onto a global Ganymede DEM
# produce a mirrored copy of the visible disk past the planetary limb,
# because usgscsm UsgsAstroFrameSensorModel::groundToImage performs a
# pure perspective divide with no body-occlusion test. The query phase
# now detects via a four-corner test that part of the projected bbox
# is back-of-body and propagates --model-occlusion to every per-tile
# invocation, which wraps the camera with OcclusionAwareCameraModel and
# rejects ground points whose camera ray points outward at the local
# surface (within 1 deg of grazing or worse).
#
# The DEM clip extends past the visible limb so the bug would manifest
# in an unfixed build (the gold output has nodata where the unfixed
# build would have ghost pixels).

mapproject --tr 4000 ../data/GanymedeVoyagerGalileo_dem_clip.tif \
  ../data/JNCR_2021158_34C00002_V01_0009_trim_circle.cub \
  run/run.tif --threads 1 --processes 1
