#!/bin/bash

set -x verbose
rm -rfv run

# Create a synthetic image and camera with pitch of 40
# sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o runp40/run --first 400 600 80000 --last 400 1000 80000 --num 1 --focal-length 30000 --optical-center 250 250 --image-size 500 500 --first-ground-pos 400 600 --last-ground-pos 400 1000 --roll 0 --pitch 40 --yaw 0
# and similarily for the other one

# ../data/img_pitch_minus40.tif ../data/img_pitch_minus40.tsai 
# ../data/img_pitch_plus40.tsai ../data/img_pitch_plus40.tif 
# ../data/sat_sim_DEM.tif ../data/sat_sim_ortho.tif

gcp_gen --camera-image ../data/img_pitch_minus40.tif --ortho-image ../data/sat_sim_ortho.tif --dem ../data/sat_sim_DEM.tif -o run/run.gcp

# bundle_adjust should be able to use this GCP file
bundle_adjust ../data/img_pitch_minus40.tif ../data/img_pitch_minus40.tsai run/run.gcp -o run/run --num-iterations 100 --num-passes 1 --inline-adjustments -t nadirpinhole --datum D_MARS --robust-threshold 10 --threads 1 --camera-weight 0

