#!/bin/bash

# This test exercises the image_align option --match-points-geopackage. It writes
# the inlier interest point matches between two georeferenced images to a
# GeoPackage (.gpkg) in projected units, for evaluating geolocation agreement
# rather than aligning the images (image_align doc, "Evaluating matches between
# orthoimages"). The option is available in build 1/2026 and later.
#
# No -o is passed, so no aligned image is produced. The geopackage is the only
# output validated in validate.sh.

set -x verbose
rm -rfv run

image_align ../data/image_crop.tif ../data/image_crop_4.5pix.tif \
  --output-prefix run/run                           \
  --match-points-geopackage run/matches.gpkg        \
  --alignment-transform translation
