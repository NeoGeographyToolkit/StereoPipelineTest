#!/bin/bash

set -x verbose
rm -rfv run

# Solve for jitter witha rig
jitter_solve --rig-config ../data/jitter_rig/rig_hirise.txt --camera-position-weight 1e+4 --forced-triangulation-distance 501589 --min-matches 1 --min-triangulation-angle 1e-10 --num-iterations 5 --max-pairwise-matches 1500 --match-files-prefix ../data/jitter_rig/ba_sim_hirise_jitter0.0/run --max-initial-reprojection-error 10 --tri-weight 0.1 --tri-robust-threshold 0.1 --num-anchor-points-per-tile 10 --num-anchor-points-extra-lines 1000 --anchor-weight 0.1 --anchor-dem ../data/jitter_rig/ref.tif --heights-from-dem ../data/jitter_rig/ref.tif --heights-from-dem-uncertainty 10 ../data/jitter_rig/sim_hirise_jitter0.0/linescan-{fwd,nadir}-{c1,c2}.tif ../data/jitter_rig/sim_hirise_jitter2.0/linescan-{fwd,nadir}-{c1,c2}.json -o run/run --num-passes 1 --threads 1

