#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --perturb-cameras --camera-list ../data/dart/cam_list.txt --dem ../data/dart/SERC_DSM_WGS84.tif --jitter-frequency 5 --horizontal-uncertainty "0 2 0" -o run/run --velocity 7500

