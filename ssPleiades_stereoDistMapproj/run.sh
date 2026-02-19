#!/bin/bash

# Test stereo_dist with --mapproject flag.
# Uses Pleiades images with RPC XML cameras.

set -x verbose
rm -rfv run

dem="../data/pleiades_dem.tif"
img1="../data/IMG_PHR1B_P_202204132246314_SEN_6304928201-1_R1C1_crop.TIF"
img2="../data/IMG_PHR1B_P_202204132247161_SEN_6304929201-1_R1C1_crop.tif"
cam1="../data/RPC_PHR1B_P_202204132246314_SEN_6304928201-1.XML"
cam2="../data/RPC_PHR1B_P_202204132247161_SEN_6304929201-1.XML"

srs='+proj=stere +lat_0=90 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
projwin="-827855 1928110 -827631 1927887"
pdopt='--stereographic --proj-lon 0 --proj-lat 90 --tr 0.5'

stereo_dist                      \
  --mapproject                   \
  --dem $dem                     \
  --t_srs "$srs"                 \
  --tr 0.5                       \
  --t_projwin $projwin           \
  $img1 $img2                    \
  $cam1 $cam2                    \
  run/run                        \
  --alignment-method none        \
  --corr-seed-mode 1             \
  --subpixel-mode 1              \
  --tile-size 600                \
  --tile-padding 128             \
  --stereo-algorithm asp_mgm     \
  --point2dem-options "$pdopt"
