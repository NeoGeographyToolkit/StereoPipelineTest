#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 450 1500 -1000 --last 450 2500 -1000 --num 5 --focal-length 5000 --optical-center 150 100 --image-size 300 200 --first-ground-pos 450 2000 --last-ground-pos 450 2000

# Create orthoimages for inspection
for ((i = 10000; i < 10005 ; i++)); do
  mapproject ../data/sat_sim_DEM.tif run/run-${i}.tif run/run-${i}.tsai run/run-${i}.map.tif
done

