#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 450 1500 -1000 --last 450 2500 -1000 --num 5 --focal-length 5000 --optical-center 150 100 --image-size 300 200 --first-ground-pos 450 1500 --last-ground-pos 450 2500 --roll 0 --pitch 25 --yaw 0 --velocity 7500 --jitter-frequency 45 --horizontal-uncertainty "1.0 1.0 1.0"

