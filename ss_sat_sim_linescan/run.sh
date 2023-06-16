#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 150 100 --image-size 300 600 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 40 --yaw 0 --sensor-type linescan --velocity 7000 --horizontal-uncertainty '0 0 0'

mapproject ../data/sat_sim_DEM.tif run/run.tif run/run.json run/run.map.tif

