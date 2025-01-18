#!/bin/bash

set -x verbose
rm -rfv run

dem=../data/sat_sim_DEM.tif

# sat sim with a linescan and frame rig
sat_sim --dem $dem --ortho ../data/sat_sim_ortho.tif -o run/run --first 450 1000 10000 --last 450 1050 10000 --num 2 --first-ground-pos 450 1000 --last-ground-pos 450 1050 --roll 0 --pitch 40 --yaw 0 --sensor-type linescan,frame,frame --velocity 7000 --horizontal-uncertainty '0 0 0' --rig-config ../data/sim_rig_ls_frame.txt --save-as-csm

# mapproject each image and camera
for img in run/run*c{1,2,3}.tif; do 
  cam=${img/.tif/.json}
  map=${img/.tif/.map.tif}
  echo $img $cam $map
  mapproject $dem \
    $img $cam $map
done

img=$(ls run/run*c{1,2,3}.tif)
cam=$(echo $img | sed 's/.tif/.json/g')
map=$(echo $img | sed 's/.tif/.map.tif/g')
map="$map $dem"
echo img is $img
echo cam is $cam
echo map is $map

# Test bundle_adjust
bundle_adjust                          \
  --threads 1                          \
  --ip-per-image 5000                  \
  --forced-triangulation-distance 1000 \
  --min-triangulation-angle 1e-10      \
  --min-matches 0                      \
  $img $cam                            \
  --mapprojected-data "$map"           \
  -o run/ba/run

# Test solving for jitter with a linescan-frame rig
jitter_solve                                \
  --threads 1                               \
  --num-iterations 10                       \
  --forced-triangulation-distance 1000      \
  --min-triangulation-angle 1e-10           \
  run/run-c1.tif                            \
  run/run-images-c2.txt                     \
  run/run-images-c3.txt                     \
  run/run-c1.json                           \
  run/run-cameras-c2.txt                    \
  run/run-cameras-c3.txt                    \
  --match-files-prefix run/ba/run           \
  --rig-config ../data/sim_rig_ls_frame.txt \
  --min-matches 0                           \
  --max-initial-reprojection-error 1000     \
  -o run/jitter/run
  
# Sanity check. Test loading a prior camera
ls run/run-c1.json > run/list.txt
sat_sim --dem $dem --ortho ../data/sat_sim_ortho.tif -o run/reload/run --first 450 1000 10000 --last 450 1050 10000 --num 2 --first-ground-pos 450 1000 --last-ground-pos 450 1050 --roll 0 --pitch 40 --yaw 0 --sensor-type linescan --velocity 7000 --horizontal-uncertainty '0 0 0'  --save-as-csm --camera-list run/list.txt --image-size 100 100 --focal-length 1000 --optical-center 50 50

