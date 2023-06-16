#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 400 600 10000 --last 400 1000 10000 --num 5 --focal-length 10000 --optical-center 150 100 --image-size 300 200 --first-ground-pos 400 600 --last-ground-pos 400 1000 --roll 0 --pitch 40 --yaw 0 --velocity 7500 --jitter-frequency 45 --horizontal-uncertainty "1.0 1.0 1.0"

