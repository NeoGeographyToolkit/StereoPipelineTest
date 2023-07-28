#!/bin/bash

set -x verbose
rm -rfv run

# Linescan camera with pitch of 40 degrees
sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run-l --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 500 400 --image-size 1000 800 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 40 --yaw 0 --sensor-type linescan --velocity 7000 --horizontal-uncertainty '0 0 0' --square-pixels --save-ref-cams

# Pinhole cameraras with pitch of 0 degrees. Save as CSM to be able to mix with linescan.
sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run-p --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 500 400 --image-size 1000 800 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 0 --yaw 0 --sensor-type pinhole --velocity 7000 --horizontal-uncertainty '0 0 0' --save-as-csm --save-ref-cams

# Run bundle adjustment with this data to get interest points
bundle_adjust --threads 1 --max-pairwise-matches 5000 run/run-l.tif run/run-p-1000[0-4].tif run/run-l.json run/run-p-1000[0-4].json -o run/run

# Solve for jitter
jitter_solve --num-iterations 10 --rotation-weight 0.1 --translation-weight 0.1 --threads 1 run/run-l.tif run/run-p-images.txt run/run-l.json run/run-p-cameras.txt --clean-match-files-prefix run/run -o run/jitter/run --roll-weight 0.1 --yaw-weight 0.1 --heights-from-dem ../data/sat_sim_DEM.tif --heights-from-dem-weight 0.1 --heights-from-dem-robust-threshold 0.1
