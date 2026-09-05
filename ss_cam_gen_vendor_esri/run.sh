#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# The images need not exist. Only their names matter, matched to the
# exterior-orientation records by file name. This exercises the honest ESRI
# vendor parsing (position + omega/phi/kappa, plus the camera CSV) and the
# grid-to-true-north convergence, without needing the (large) frame images.
printf "%s\n" 20251113_155312_032_003.tif 20251113_155327_035_003.tif > run/image_list.txt

cam_gen --vendor esri                       \
  --extrinsics  ../data/rcd30_eo.txt        \
  --intrinsics  ../data/rcd30_cam.csv       \
  --image-list  run/image_list.txt          \
  --output-dir  run                         \
  --t_srs       EPSG:32617
