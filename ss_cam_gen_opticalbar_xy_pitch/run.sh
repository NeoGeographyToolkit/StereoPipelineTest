#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Optical bar cameras with a different pixel pitch along columns (x) and rows (y)
perl -pe 's/^pitch = .*$/pitch = 0.0000995 0.0001/'                \
  ../data/D3C1214-100097A013.tsai > run/D3C1214-100097A013.tsai
perl -pe 's/^pitch = .*$/pitch = 0.000139 0.00013947001394700001/' \
  ../data/DS1105-2248DA079_optical_bar.tsai > run/DS1105-2248DA079_optical_bar.tsai

# Read the two pitches and convert to a linescan camera
cam_gen --camera-type linescan                                     \
  ../data/D3C1214-100097A013.jpg                                   \
  --input-camera run/D3C1214-100097A013.tsai                       \
  -o run/linescan.json

# Fit an optical bar camera from a sample file and write the two pitches
ll_vals='99.55 31.266 101.866 31.55 101.916 31.416 99.55 31.133'
cam_gen                                                            \
  --camera-type opticalbar                                         \
  --lon-lat-values "$ll_vals"                                      \
  --sample-file run/DS1105-2248DA079_optical_bar.tsai              \
  ../data/DS1105-2248DA079.tif                                     \
  --reference-dem ../data/optical_bar_dem.tif                      \
  --refine-camera                                                  \
  -o run/opticalbar.tsai

# Convert the optical bar camera to pinhole
convert_pinhole_model                                              \
  ../data/D3C1214-100097A013.jpg                                   \
  run/D3C1214-100097A013.tsai                                      \
  --camera-to-ground-dist 170000                                   \
  -o run/pinhole.tsai
