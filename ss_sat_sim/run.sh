#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 450 1500 -1000 --last 450 2500 -1000 --num 2 --first-ground-pos 450 2000 --last-ground-pos 450 2000 --rig ../data/sim_rig.txt

# Create orthoimages for inspection
for f in run/*c[0-9].tif; do echo $f; g=${f/.tif/.tsai}; h=${f/.tif/.map.tif}; mapproject ../data/sat_sim_DEM.tif $f $g $h; done

