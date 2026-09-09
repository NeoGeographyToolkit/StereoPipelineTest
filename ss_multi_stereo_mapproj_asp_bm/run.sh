#!/bin/bash

# multi_stereo in dem_mosaic mode on a small CaSSIS Jezero subset, with the
# block-matching algorithm (asp_bm). This is the asp_bm counterpart of
# ss_multi_stereo_mapproj (which uses asp_mgm). Together they exercise both tile
# pools of the distributed driver: asp_mgm pools the blend tiles, asp_bm pools the
# refinement tiles.
#
# Mapproject two left and two right framelets at native 4.59 m onto the blurred CTX,
# build a cross-look overlap list, then run pairwise stereo and mosaic the per-pair
# DEMs into one DEM and a maximum triangulation error mosaic. The cameras are the
# final bundle-adjusted CSM cameras. See the multi_stereo documentation.

set -x verbose
rm -rfv run
mkdir -p run/maps

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
sharpCtx=run/ctx_sharp_crop.tif
gdal_translate -projwin -4300 8000 -1500 7000 \
  $data/ref/ctx_blur_18m.tif $blurCtx
gdal_translate -projwin -4300 8000 -1500 7000 \
  $data/ref/ctx_18m.tif $sharpCtx

# The two left and two right framelet stems
L1=cas_cal_sc_20210725T202821-20210725T202825-16378-10-PAN-838849161-7-0__4_0
L2=cas_cal_sc_20210725T202821-20210725T202825-16378-10-PAN-838849161-8-0__4_0
R1=cas_cal_sc_20210725T202910-20210725T202914-16378-10-PAN-838849162-1-0__4_0
R2=cas_cal_sc_20210725T202911-20210725T202915-16378-10-PAN-838849162-2-0__4_0

# Mapproject each framelet at native resolution onto the blurred CTX. All share the
# same resolution, as stereo requires for mapprojected input.
for s in $L1 $L2 $R1 $R2; do
  mapproject                        \
    --tr $mapRes                    \
    $blurCtx                        \
    $data/cub/$s.cub                \
    $data/cam/$s.json               \
    run/maps/$s.tif
done

# Overlap list: each left framelet paired with each right framelet (cross look).
# Columns: left_image right_image left_camera right_camera.
ovl=run/overlap.txt
: > $ovl
for L in $L1 $L2; do
  for R in $R1 $R2; do
    echo "run/maps/$L.tif run/maps/$R.tif $data/cam/$L.json $data/cam/$R.json" >> $ovl
  done
done

# This test drives multi_stereo with --conv-angle-prefix (the asp_mgm test uses
# --overlap-list). bundle_adjust normally writes the convergence angle report and the
# adjusted cameras under an output prefix. Here we stage the equivalent inputs under
# the prefix run/ba: the four cameras (named run/ba-<image>.json), and a report
# listing all four cross-look pairs with a median convergence angle of 30 degrees, so
# --conv-angle-range 15,45 selects them all. multi_stereo then builds the same overlap
# list as above, so the DEM must match the gold made from that overlap list.
baPrefix=run/ba
for s in $L1 $L2 $R1 $R2; do
  cp $data/cam/$s.json $baPrefix-$s.json
done
conv=$baPrefix-convergence_angles.txt
echo "# left_image right_image 25% 50% 75% num_matches" > $conv
for L in $L1 $L2; do
  for R in $R1 $R2; do
    echo "run/maps/$L.tif run/maps/$R.tif 28 30 32 100" >> $conv
  done
done

# Run stereo on each pair, make a per-pair DEM, and mosaic them. The seed DEM is the
# blurred CTX the images were mapprojected onto. The sharp CTX is the blunder-filter
# reference. --processes runs two pairs at a time, each parallel_stereo with two
# threads.
multi_stereo                                                                  \
  --mode dem_mosaic                                                           \
  --conv-angle-prefix $baPrefix                                               \
  --conv-angle-range 15,45                                                    \
  --dem $blurCtx                                                              \
  --ref-dem $sharpCtx                                                         \
  --blunder-tol 100                                                           \
  --processes 2                                                               \
  --threads 2                                                                 \
  --stereo_options "--alignment-method none --stereo-algorithm asp_bm --subpixel-mode 2 --corr-seed-mode 1 --min-matches 5 --ip-per-tile 2000 --mapproj-geolocation-uncertainty 0 --ip-match-radius 20" \
  --point2dem-options "--tr $demRes --t_srs '$proj' --errorimage --max-valid-triangulation-error 8" \
  --out_dir run/stereo
