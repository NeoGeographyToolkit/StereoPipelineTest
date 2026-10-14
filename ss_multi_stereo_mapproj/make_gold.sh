#!/bin/bash

# Regenerate the gold for this test from the plain pairwise path, independent of
# multi_stereo. For each overlap pair run parallel_stereo (one full invocation),
# then point2dem on a FIXED grid and projection, then dem_mosaic the per-pair DEMs.
# That mosaic becomes the gold. Because the grid and projection are pinned, and the
# point clouds are the same, the multi_stereo result (run.sh, which runs point2dem
# internally) must match this gold exactly. This script also runs run.sh and reports
# the difference.
#
# The gold is data and is never committed. This script documents how it was made.

set -e
here=$(cd "$(dirname "$0")" && pwd)
cd "$here"

# Same grid and projection as run.sh.
demRes=18
proj="+proj=stere +lat_0=18.4 +lon_0=77.5 +k=1 +x_0=0 +y_0=0 +R=3396190 +units=m +no_defs"

# The stereo options must match run.sh exactly. --propagate-errors is set so the
# point cloud carries the horizontal and vertical uncertainty bands, which point2dem
# then grids. It subtly changes the DEM too, so the gold must be made with it on.
stereoOpts="--alignment-method none --stereo-algorithm asp_mgm --subpixel-mode 9 --corr-seed-mode 1 --min-matches 5 --ip-per-tile 2000 --mapproj-geolocation-uncertainty 0 --ip-match-radius 20 --propagate-errors --horizontal-stddev 1.0 1.0"

# Run the test first. This creates run/maps, run/overlap.txt, run/ctx_*_crop.tif and
# the multi_stereo result in run/stereo.
bash run.sh > make_gold_run.log 2>&1

blurCtx=run/ctx_blur_crop.tif

# Plain pairwise path into gold_work. The overlap list has two columns (left and
# right mapprojected image), the same as run.sh feeds multi_stereo. The camera for
# each image is <data>/cam/<stem>.json, the same mapping multi_stereo makes from its
# image and camera lists.
data=../data/cassis_jezero
rm -rf gold_work
mkdir -p gold_work
i=0
dems=""
while read L R; do
  [ -z "$L" ] && continue
  LC=$data/cam/$(basename "$L" .tif).json
  RC=$data/cam/$(basename "$R" .tif).json
  pre=gold_work/pair$i/run
  mkdir -p gold_work/pair$i
  # A pair may fail to resolve (empty point cloud), just as in multi_stereo. Tolerate
  # it and mosaic only the pairs that produced a DEM. Both paths run the same stereo,
  # so the same pairs survive.
  parallel_stereo --processes 1 --threads-multiprocess 2 --threads-singleprocess 2 \
    $stereoOpts "$L" "$R" "$LC" "$RC" $pre $blurCtx >> make_gold_run.log 2>&1 || true
  point2dem --tr $demRes --t_srs "$proj" --max-valid-triangulation-error 8 \
    --propagate-errors \
    -o $pre $pre-PC.tif >> make_gold_run.log 2>&1 || true
  [ -f $pre-DEM.tif ] && dems="$dems $pre-DEM.tif"
  [ -f $pre-HorizontalStdDev.tif ] && hstd="$hstd $pre-HorizontalStdDev.tif"
  [ -f $pre-VerticalStdDev.tif ]   && vstd="$vstd $pre-VerticalStdDev.tif"
  i=$((i+1))
done < run/overlap.txt

# Mosaic the per-pair products (same order and combine mode as run.sh), set the gold.
# The DEM and the two uncertainty mosaics are all blended (plain dem_mosaic).
mkdir -p gold
dem_mosaic $dems -o gold_work/plain >> make_gold_run.log 2>&1
cp gold_work/plain-tile-0.tif gold/run-DEM.tif
dem_mosaic $hstd -o gold_work/hstd >> make_gold_run.log 2>&1
cp gold_work/hstd-tile-0.tif gold/run-HorizontalStdDev.tif
dem_mosaic $vstd -o gold_work/vstd >> make_gold_run.log 2>&1
cp gold_work/vstd-tile-0.tif gold/run-VerticalStdDev.tif
rm -f gold/run-DEM.tif.aux.xml gold/run-HorizontalStdDev.tif.aux.xml \
      gold/run-VerticalStdDev.tif.aux.xml

echo "Gold set from the plain pairwise path: gold/run-DEM.tif,"
echo "gold/run-HorizontalStdDev.tif, gold/run-VerticalStdDev.tif."
echo "Comparing multi_stereo (run.sh) against the gold:"
for f in run-DEM.tif run-HorizontalStdDev.tif run-VerticalStdDev.tif; do
  cmp run/stereo/$f gold/$f \
    && echo "IDENTICAL bytes: $f multi_stereo == plain pairwise." \
    || echo "Bytes differ in $f. Inspect with geodiff/gdalinfo."
done
