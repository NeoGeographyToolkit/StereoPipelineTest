#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run --first 428 688 -2000 --last 428 911 -2000 --num 5 --focal-length 5000 --optical-center 100 100 --image-size 200 200 --first-ground-pos 428 688 --last-ground-pos 428 911 --roll 0 --pitch 25 --yaw 0

