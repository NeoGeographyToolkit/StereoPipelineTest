#!/bin/bash

# multi_stereo in dem_mosaic mode on a small CaSSIS Jezero subset.
#
# Mapproject two left and two right framelets at native 4.59 m onto the blurred CTX,
# build a cross-look overlap list, then run pairwise stereo and mosaic the per-pair DEMs
# into one DEM and a maximum triangulation error mosaic. The cameras are the final
# bundle-adjusted CSM cameras. See the multi_stereo documentation.

set -x verbose
rm -rfv run
mkdir -p run/maps

# Exercise multi_stereo's --nodes-list. localhost runs the pooled tiles locally, so
# the result is unchanged.
echo localhost > run/nodes.txt

data=../data/cassis_jezero
mapRes=4.59
demRes=18
# Fixed output projection for point2dem (the CTX projection). Pinning both the
# grid (--tr) and the projection (--t_srs) makes every per-pair DEM land on the
# same grid, so the mosaic is deterministic and matches a plain
# parallel_stereo + point2dem run exactly.
proj="+proj=stere +lat_0=18.4 +lon_0=77.5 +k=1 +x_0=0 +y_0=0 +R=3396190 +units=m +no_defs"

# Crop the seed and reference CTX to a small central window that all four
# framelets overlap. This shrinks the mapprojected images and the stereo
# extent so the test runs faster while still going through all the motions.
# The window is in projected coordinates (meters), ulx uly lrx lry.
blurCtx=run/ctx_blur_crop.tif
gdal_translate -projwin -4300 8000 -1500 7000 \
  $data/ref/ctx_blur_18m.tif $blurCtx

# The two left and two right framelet stems
L1=cas_cal_sc_20210725T202821-20210725T202825-16378-10-PAN-838849161-7-0__4_0
L2=cas_cal_sc_20210725T202821-20210725T202825-16378-10-PAN-838849161-8-0__4_0
R1=cas_cal_sc_20210725T202910-20210725T202914-16378-10-PAN-838849162-1-0__4_0
R2=cas_cal_sc_20210725T202911-20210725T202915-16378-10-PAN-838849162-2-0__4_0

# Mapproject each framelet at native resolution onto the blurred CTX. All share the same
# resolution, as stereo requires for mapprojected input. The four are run in parallel to
# save wall-clock time; the output rasters are independent of each other.
for s in $L1 $L2 $R1 $R2; do
  mapproject                        \
    --tr $mapRes                    \
    $blurCtx                        \
    $data/cub/$s.cub                \
    $data/cam/$s.json               \
    run/maps/$s.tif &
done
wait

# Image and camera lists in matching order, and a 2-column overlap list pairing each
# left framelet with each right framelet (cross look).
imgList=run/image_list.txt
camList=run/camera_list.txt
: > $imgList; : > $camList
for s in $L1 $L2 $R1 $R2; do
  echo "run/maps/$s.tif"   >> $imgList
  echo "$data/cam/$s.json" >> $camList
done
ovl=run/overlap.txt
: > $ovl
for L in $L1 $L2; do
  for R in $R1 $R2; do
    echo "run/maps/$L.tif run/maps/$R.tif" >> $ovl
  done
done

# Run stereo on each pair, make a per-pair DEM, and mosaic them. The blurred CTX
# (--dem) is both the mapprojection DEM and the blunder-filter reference. The output
# projection is pinned with --t_srs. --processes 4 runs all four pairs at once, each
# parallel_stereo with two threads.
stereoOpts="--alignment-method none --stereo-algorithm asp_mgm --subpixel-mode 9
  --corr-seed-mode 1 --min-matches 5 --ip-per-tile 2000
  --mapproj-geolocation-uncertainty 0 --ip-match-radius 20"
demOpts="--tr $demRes --t_srs '$proj' --errorimage --max-valid-triangulation-error 8"

multi_stereo                     \
  --mode dem_mosaic              \
  --image-list $imgList          \
  --camera-list $camList         \
  --overlap-list $ovl            \
  --dem $blurCtx                 \
  --blunder-tol 100              \
  --processes 4                  \
  --threads 2                    \
  --nodes-list run/nodes.txt     \
  --stereo-options "$stereoOpts" \
  --point2dem-options "$demOpts" \
  --output-prefix run/stereo/run
