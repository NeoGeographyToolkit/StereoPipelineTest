#!/bin/bash

set -x verbose
rm -rfv run

# Test disp2ip

mkdir -p run

ls ../data/disp2ip/fltr/left/left_filtered*.png   > run/left_filtered.txt
ls ../data/disp2ip/fltr/right/right_filtered*.png > run/right_filtered.txt
ls ../data/disp2ip/raw/left/left_raw*.png         > run/left_raw.txt

# Stereo runs lists. Each run must have an F.tif file.
ls ../data/disp2ip/stereo_[0-9][0-9]/run-F.tif | perl -p -e 's/-F\.tif//' > run/stereo.txt

# Optical centers
# Left images
for f in $(cat run/left_filtered.txt); do 
  echo $f 1064 1025 
done > run/optical_centers.txt
# Append the right images
for f in $(cat run/right_filtered.txt); do 
  echo $f 1055 1032 
done >> run/optical_centers.txt

# This can produce non-unique results, so run just once
# theia_sfm --rig_config ../data/disp2ip/rig_config.txt \
#     --theia_flags ../data/disp2ip/theia_flags.txt     \
#     --images '../data/disp2ip/raw/left/left_raw*.png' \
#     --out_dir ../data/disp2ip/theia_left

disp2ip --left-raw-image-list run/left_raw.txt       \
  --left-filtered-image-list run/left_filtered.txt   \
  --right-filtered-image-list run/right_filtered.txt \
  --stereo-prefix-list run/stereo.txt                \
  --optical-center-list run/optical_centers.txt      \
  --input-nvm ../data/disp2ip/theia_left/cameras.nvm \
  --output-nvm run/theia_fltr/cameras.nvm
