#!/bin/bash

set -x verbose
rm -rfv run

sat_sim --perturb-cameras --camera-list ../data/dart/cam_list.txt --dem ../data/dart/SERC_DSM_WGS84.tif --jitter-frequency 5 --horizontal-uncertainty "0 2 0" -o run/run-jitter --velocity 7500
sat_sim --random-pose-perturbation --camera-list ../data/dart/cam_list.txt --dem ../data/dart/SERC_DSM_WGS84.tif --horizontal-uncertainty "0 2 0" -o run/run-rand-pose --velocity 7500

sat_sim --random-position-perturbation 2.0 --camera-list ../data/dart/cam_list.txt --dem ../data/dart/SERC_DSM_WGS84.tif --horizontal-uncertainty "0 2 0" -o run/run-rand-position --velocity 7500

