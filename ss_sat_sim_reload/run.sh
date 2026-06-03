#!/bin/bash

# Render a map-projected ortho into existing (external) cameras, similar in
# spirit to ISIS map2cam. This is the sat_sim --camera-list mode. The key
# point: when the camera already exists, the satellite velocity is not needed
# (it is only used when creating a camera). This test reloads cameras without
# --velocity (and without --focal-length / --optical-center / --first / --last),
# as a regression guard against sat_sim wrongly demanding velocity. Both the
# linescan and the pinhole (frame) sensor types are exercised.

set -x verbose
rm -rfv run

dem=../data/sat_sim_DEM.tif
ortho=../data/sat_sim_ortho.tif

# Step 1: create a linescan CSM camera. Creating a camera legitimately needs
# the velocity, since it sets the camera positions and times along the orbit.
# Note: the requested image height of 100 is auto-adjusted down (to about 16
# lines here) so the pixels are roughly square. So the created camera has a
# native size of about 100 x 16.
sat_sim --dem $dem --ortho $ortho -o run/gen_ls/run \
  --first 450 1000 10000 --last 450 1050 10000 --num 2 \
  --first-ground-pos 450 1000 --last-ground-pos 450 1050 \
  --roll 0 --pitch 0 --yaw 0 --sensor-type linescan --velocity 7000 \
  --image-size 100 100 --focal-length 1000 --optical-center 50 50 \
  --save-as-csm
ls run/gen_ls/run.json > run/list_ls.txt

# Step 2a: reload the existing linescan camera at its native size and render
# the ortho into it, with NO --velocity. Only --image-size is given (the user
# picks the output resolution). This failed before the fix with "The satellite
# velocity must be specified". With the native 16 lines, this reproduces the
# camera geometry.
sat_sim --dem $dem --ortho $ortho --camera-list run/list_ls.txt \
  --sensor-type linescan --image-size 100 16 -o run/reload_ls_native/run

# Step 2b: reload the same camera but ask for more lines (100) than the camera
# has (16). In this mode --image-size is used as given (no square-pixel
# auto-adjust), so each extra line samples the orbit at a later time. The raw
# image is taller (100 rows) and covers more ground along-track, extrapolating
# beyond the camera's imaged range. See the sat_sim doc, prior-camera section.
sat_sim --dem $dem --ortho $ortho --camera-list run/list_ls.txt \
  --sensor-type linescan --image-size 100 100 -o run/reload_ls/run

# Step 3: create pinhole (frame) cameras. Again, creation needs the velocity.
sat_sim --dem $dem --ortho $ortho -o run/gen_pin/run \
  --first 450 1000 10000 --last 450 1050 10000 --num 2 \
  --first-ground-pos 450 1000 --last-ground-pos 450 1050 \
  --roll 0 --pitch 0 --yaw 0 --sensor-type pinhole --velocity 7000 \
  --image-size 100 100 --focal-length 1000 --optical-center 50 50

# Step 4: reload the existing pinhole cameras and render the ortho into them,
# with NO --velocity. The non-linescan path must work the same way.
ls run/gen_pin/run-*.tsai > run/list_pin.txt
sat_sim --dem $dem --ortho $ortho --camera-list run/list_pin.txt \
  --sensor-type pinhole --image-size 100 100 -o run/reload_pin/run
