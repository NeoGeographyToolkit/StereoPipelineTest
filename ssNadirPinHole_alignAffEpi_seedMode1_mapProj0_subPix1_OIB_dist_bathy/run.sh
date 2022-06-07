#!/bin/bash

set -x verbose
rm -rfv run

lthresh=158
rthresh=141

image_calc -c "max($lthresh, var_0)" --output-nodata-value $lthresh ../data/img_icebridge2.tif -o run/left_mask.tif
image_calc -c "max($lthresh, var_0)" --output-nodata-value $lthresh ../data/img_icebridge3.tif -o run/right_mask.tif

bathy_plane_calc --shapefile ../data/bathy_pinhole_shoreline.shp --dem \
    run/run-DEM.tif --outlier-threshold 0.2                            \
    --bathy-plane run/bathy-plane-nadirpinhole.txt

parallel_stereo --alignment-method affineepipolar                \
  --xcorr-threshold -1 --corr-kernel 5 5                         \
    --cost-mode 4  --stereo-algorithm asp_mgm --threads-single 8 \
    --corr-seed-mode 1 --session-type nadirpinhole               \
    ../data/img_icebridge2.tif ../data/img_icebridge3.tif        \
    ../data/img_icebridge2.tsai ../data/img_icebridge3.tsai      \
    --left-bathy-mask run/left_mask.tif                          \
    --right-bathy-mask run/right_mask.tif                        \
    --refraction-index 1.333                                     \
    --bathy-plane run/bathy-plane-nadirpinhole.txt               \
    run/run

point2dem  --t_srs '+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs' --tr 0.4 run/run-PC.tif
