#!/bin/bash

# KPLO ShadowCam testcase.
# https://stereopipeline.readthedocs.io/en/latest/examples/shadowcam.html
#
# Exercises isd_generate (CSM ISD creation) -> bundle_adjust ->
# parallel_stereo -> point2dem on a cropped KPLO ShadowCam pair.
#
# The cropped cubes are anchored at pixel (0, 0). isd_generate ignores any
# crop line offset, so a cube cropped away from the origin would produce a
# wrong CSM camera. The crops here only reduce the line/sample extent from
# the origin, so the CSM timing origin is preserved.
#
# This needs the ASP custom build of ALE and ISIS (KPLO ShadowCam support),
# included in the ASP conda environment as of ASP 3.7.0. The stereo and
# bundle_adjust tools need the custom USGSCSM with the KPLOSHADOWCAM model.

set -x verbose
rm -rfv run
mkdir -p run

# Create a CSM ISD for each cropped cube. The cube is passed twice: once as
# the -k kernel source (its own attached SPICE) and once as the positional
# input image.
isd_generate -k ../data/M074289249SE_crop.cub ../data/M074289249SE_crop.cub \
  -o run/M074289249SE_crop.json
isd_generate -k ../data/M074296291SE_crop.cub ../data/M074296291SE_crop.cub \
  -o run/M074296291SE_crop.json

# Bundle adjustment on the cropped cubes and the CSM ISDs.
bundle_adjust                                   \
  ../data/M074289249SE_crop.cub                 \
  ../data/M074296291SE_crop.cub                 \
  run/M074289249SE_crop.json                    \
  run/M074296291SE_crop.json                    \
  --ip-per-image 30000                          \
  --max-pairwise-matches 5000                   \
  --num-iterations 50                           \
  --camera-weight 0 --tri-weight 0.1            \
  --remove-outliers-params "75 3 200 200"       \
  -o run/ba/run

# Stereo on the overlap window of the same cropped cubes, using the
# bundle-adjusted CSM state files.
proj="+proj=stere +lat_0=-90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +R=1737400 +units=m +no_defs"

parallel_stereo                                 \
  --left-image-crop-win  2133 629 600 600       \
  --right-image-crop-win 1511 4341 600 600      \
  --alignment-method local_epipolar             \
  --stereo-algorithm asp_mgm                    \
  --subpixel-mode 9                             \
  ../data/M074289249SE_crop.cub                 \
  ../data/M074296291SE_crop.cub                 \
  run/ba/run-M074289249SE_crop.adjusted_state.json \
  run/ba/run-M074296291SE_crop.adjusted_state.json \
  run/stereo/run

point2dem --tr 5 --t_srs "$proj" --errorimage run/stereo/run-PC.tif
