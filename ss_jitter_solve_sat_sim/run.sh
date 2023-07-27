#!/bin/bash

set -x verbose
rm -rfv run

# Create forward and nadir-looking cameras
sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/f --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 150 100 --image-size 300 600 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 30 --yaw 0 --sensor-type linescan --velocity 7000 --horizontal-uncertainty '0 0 0'
sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/n --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 150 100 --image-size 300 600 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 0 --yaw 0 --sensor-type linescan --velocity 7000 --horizontal-uncertainty '0 0 0'

# Create match files
bundle_adjust run/f.tif run/n.tif run/f.json run/n.json -o run/run --threads 1 --num-iterations 10 --num-passes 1

# Solve for jitter with these cameras with the yaw constraint
jitter_solve run/f.tif run/n.tif run/f.json run/n.json -o run/run --match-files-prefix run/run --heights-from-dem ../data/sat_sim_DEM.tif --heights-from-dem-weight 0.1 --heights-from-dem-robust-threshold 0.1 --yaw-weight 10000 --rotation-weight 0.1 --translation-weight 0.1 --threads 1 --num-iterations 10

