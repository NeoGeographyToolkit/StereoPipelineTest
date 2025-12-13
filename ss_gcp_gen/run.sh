#!/bin/bash

set -x verbose
rm -rfv run

# Create a synthetic image and camera with pitch of 40. The command included for reference.
# sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o runp40/run --first 400 600 80000 --last 400 1000 80000 --num 1 --focal-length 30000 --optical-center 250 250 --image-size 500 500 --first-ground-pos 400 600 --last-ground-pos 400 1000 --roll 0 --pitch 40 --yaw 0

# Test gcp_gen on this synthetic data
gcp_gen --camera-image ../data/img_pitch_minus40.tif --ortho-image ../data/sat_sim_ortho.tif --dem ../data/sat_sim_DEM.tif -o run/run.gcp --output-prefix run/run

# bundle_adjust should be able to use this GCP file. Test --max-gcp-reproj-err.
bundle_adjust ../data/img_pitch_minus40.tif ../data/img_pitch_minus40.tsai run/run.gcp -o run/run --num-iterations 100 --num-passes 2 --inline-adjustments -t nadirpinhole --datum D_MARS --robust-threshold 10 --threads 1 --camera-weight 0 --max-gcp-reproj-err 0.5

