#!/bin/bash

set -x verbose
rm -rfv run

# Test amplitude set in micro-radians

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 450 1500 2400 --last 450 2500 2400 --num 5 --focal-length 5000 --optical-center 150 100 --image-size 300 200 --first-ground-pos 450 1500 --last-ground-pos 450 2500 --roll 0 --pitch 25 --yaw 0 --velocity 7500 --jitter-frequency "45 45" --jitter-amplitude "416.667000000 416.667000000 416.667000000 416.667000000 416.667000000 416.667000000" --jitter-phase "0.1 0.1 0.1 0.1 0.1 0.1" --no-images
