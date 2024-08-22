#!/bin/bash

set -x verbose
rm -rfv run

# Linescan camera with pitch of 40 degrees
sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run-l --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 500 400 --image-size 1000 800 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 40 --yaw 0 --sensor-type linescan --velocity 7000 --horizontal-uncertainty '0 0 0' --save-ref-cams

# Pinhole cameraras with pitch of 0 degrees. Save as CSM to be able to mix with linescan.
sat_sim --dem ../data/sat_sim_DEM.tif --ortho ../data/sat_sim_ortho.tif -o run/run-p --first 450 1000 10000 --last 450 1300 10000 --num 5 --focal-length 10000 --optical-center 500 400 --image-size 1000 800 --first-ground-pos 450 1000 --last-ground-pos 450 1300 --roll 0 --pitch 0 --yaw 0 --sensor-type pinhole --velocity 7000 --horizontal-uncertainty '0 0 0' --save-as-csm --save-ref-cams

# Set up the camera uncertainties
for f in run/run-l.tif run/run-p-1000[0-4].tif; do ((i=i+1)); ((j=j+1)); echo $f 5 3; done > run/camera_uncertainty.txt

# Run bundle adjustment with this data to get interest points. Use the isis cnet format
bundle_adjust --threads 1 --max-pairwise-matches 5000 run/run-l.tif run/run-p-1000[0-4].tif run/run-l.json run/run-p-1000[0-4].json -o run/run --output-cnet-type isis-cnet --num-iterations 10 --camera-position-uncertainty run/camera_uncertainty.txt

# Solve for jitter. Use the isis cnet format, anchor points, and a DEM
jitter_solve --num-iterations 10 --rotation-weight 0.1 --threads 1 run/run-l.tif run/run-p-images.txt run/run-l.json run/run-p-cameras.txt -o run/jitter/run --roll-weight 0.1 --yaw-weight 0.1 --heights-from-dem ../data/sat_sim_DEM.tif --heights-from-dem-uncertainty 10 --heights-from-dem-robust-threshold 0.1 --isis-cnet run/run.net --num-anchor-points 1000 --anchor-weight 0.001 --anchor-dem ../data/sat_sim_DEM.tif  --camera-position-uncertainty run/camera_uncertainty.txt

