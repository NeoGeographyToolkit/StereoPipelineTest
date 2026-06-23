#!/bin/bash

# Exercise image_align --match-points-geopackage when the two images are in
# DIFFERENT projections. Both are LOCAL STEREOGRAPHIC (metric, meters) centered
# near the scene, so distortion is minimal; the source projection center is
# shifted 0.1 deg from the reference, so the coordinates differ by a known amount
# (~8.8 km) while the imagery is essentially the same. The GeoPackage must be
# written in the REFERENCE projection with the source match coordinates
# reprojected into it, so dx/dy come out near zero (in meters). A missing
# reprojection would leave the ~8.8 km center shift in dx. Self-validating: the
# correct answer is built in (no gold). Source images are derived here from the
# shared test image, at the same resolution, with bicubic resampling.

set -x verbose
rm -rfv run
mkdir -p run

# Scene center of ../data/image_crop.tif is about lon -121.14625, lat 37.01958.
REF_SRS="+proj=stere +lat_0=37.0195833 +lon_0=-121.146250 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
SRC_SRS="+proj=stere +lat_0=37.0195833 +lon_0=-121.046250 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

gdalwarp -overwrite -t_srs "$REF_SRS" -tr 50 50 -r cubic ../data/image_crop.tif run/ref.tif
gdalwarp -overwrite -t_srs "$SRC_SRS" -tr 50 50 -r cubic ../data/image_crop.tif run/src.tif

image_align run/ref.tif run/src.tif        \
  --output-prefix run/run                  \
  --match-points-geopackage run/matches.gpkg \
  --alignment-transform homography         \
  --inlier-threshold 5
