#!/bin/bash

# CLOUD-MAC TEST: one of the small subset of tests that also run on Mac ARM64 and
# Linux ARM in the cloud (GitHub Actions, see .github/workflows in StereoPipeline).
# This subset is bundled into the StereoPipelineTest.tar release asset (tag 0.0.1).
# If that small tarball is ever lost, the cloud Mac/ARM suite can be rebuilt by
# collecting every test in this repo that carries this CLOUD-MAC TEST marker.

# Guard the image normalization step in interest point matching. The inputs are
# two adjacent same-look CaSSIS framelets (TGO, Oxia Planum). They are genuinely
# low-contrast (calibrated intensity spans only about 0.096 to 0.135) and, once
# mapprojected, overlap in a narrow band. bundle_adjust matches the mapprojected
# images with the default OBALoG detector (--ip-detect-method 0), which is not an
# OpenCV detector. The matching path used to normalize only for the OpenCV
# detectors, so OBALoG saw the raw near-flat image, its matches were geometrically
# inconsistent, and the solve filtered them all out (bundle_adjust then failed
# with "Too few points"). With normalization for all detectors the same pair
# yields well over a hundred clean matches. See validate.sh for the check.

# The framelets are mapprojected here (not shipped pre-projected) onto the cropped
# CTX DEM in ../data, so the projected images stay consistent with the inputs.

set -x verbose
rm -rfv run
mkdir -p run

d=../data
dem=$d/cassis_ox2_dem.tif

for fr in fr00 fr01; do
  mapproject --threads 1 --tr 4.59 \
    $dem                           \
    $d/cassis_ox2_L1_$fr.cub       \
    $d/cassis_ox2_L1_$fr.json      \
    run/map_$fr.tif
done

printf '%s\n%s\n' $d/cassis_ox2_L1_fr00.cub  $d/cassis_ox2_L1_fr01.cub  > run/images.txt
printf '%s\n%s\n' $d/cassis_ox2_L1_fr00.json $d/cassis_ox2_L1_fr01.json > run/cameras.txt
printf '%s\n%s\n' run/map_fr00.tif           run/map_fr01.tif           > run/mapproj.txt

bundle_adjust --threads 1                  \
  --image-list run/images.txt              \
  --camera-list run/cameras.txt            \
  --mapprojected-data-list run/mapproj.txt \
  --ip-detect-method 0                     \
  --individually-normalize                 \
  --ip-per-tile 2000                       \
  --matches-per-tile 500                   \
  --ip-match-radius 20                     \
  --num-passes 2                           \
  --num-iterations 30                      \
  --remove-outliers-params '75 3 100 100'  \
  --min-matches 1                          \
  --min-triangulation-angle 1e-10          \
  --forced-triangulation-distance 392000   \
  -o run/run 2>&1 | tee run/output.txt
