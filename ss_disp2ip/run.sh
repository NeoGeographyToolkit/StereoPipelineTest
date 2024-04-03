#!/bin/bash

set -x verbose
rm -rfv run

# Test disp2ip

mkdir -p run
ls ../data/disp2ip/rig_slog/left_nav/[0-9][0-9]_left_nav.png > run/left_filter.txt
ls ../data/disp2ip/rig_slog/right_nav/[0-9][0-9]_right_nav.png > run/right_filter.txt
ls ../data/disp2ip/rig_16bit/left_nav/[0-9][0-9]_left_nav.png > run/left_16bit.txt

# Stereo runs lists. Each run must have an F.tif file.
ls ../data/disp2ip/stereo_bm_[0-9][0-9]/run-F.tif | perl -p -e 's/-F\.tif//' > run/stereo_bm.txt

# Optical centers, from 20231128_LunarLab_GOE_EDUs.yaml
# Read each file from left_filter.txt, and print the filename
# and optical offset, which is 1.0695318193582250e+03  1.0193322778928242e+03
for f in $(cat run/left_filter.txt); do 
  echo $f 1.0695318193582250e+03 1.0193322778928242e+03
done > run/center_list.txt
# Then append the right camera optical centers.
# Those are 1.0210075240011669e+03 1.0530067929337372e+03
for f in $(cat run/right_filter.txt); do 
  echo $f 1.0210075240011669e+03 1.0530067929337372e+03
done >> run/center_list.txt

disp2ip --left-raw-image-list run/left_16bit.txt     \
  --left-filtered-image-list run/left_filter.txt     \
  --right-filtered-image-list run/right_filter.txt   \
  --stereo-prefix-list run/stereo_bm.txt             \
  --optical-center-list run/center_list.txt          \
  --input-nvm ../data/disp2ip/theia_left/cameras.nvm \
  --output-nvm run/theia_slog/cameras.nvm
  