#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 397 490 -1000 --last 397 480 -1000 --num 2 --focal-length 5000 --optical-center 100 100 --image-size 200 200 --first-ground-pos 484 510 --last-ground-pos 332 893

# Create orthoimages for inspection
for i in 10000 10001; do
  mapproject ../data/sat_sim_DEM.tif run/run-${i}.tif run/run-${i}.tsai run/run-${i}.map.tif
done

