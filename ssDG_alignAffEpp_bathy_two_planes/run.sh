#!/bin/bash

set -x verbose
rm -rfv run

lthresh=171.4873
rthresh=180.2035
waterRefractionIndex=1.333

image_calc -c "max($lthresh, var_0)" --output-nodata-value $lthresh ../data/left_bathy_b7.tif -o run/left_bathy_b7_mask.tif
image_calc -c "max($rthresh, var_0)" --output-nodata-value $rthresh ../data/right_bathy_b7.tif -o run/right_bathy_b7_mask.tif

# Apply wv_correct
wv_correct --band 3 ../data/left_bathy_b3.tif ../data/left_bathy.xml run/left_bathy_b3_corr.tif
wv_correct --band 3 ../data/right_bathy_b3.tif ../data/right_bathy.xml run/right_bathy_b3_corr.tif

mkdir -p run
echo ../data/bathy_plane1.txt ../data/bathy_plane2.txt > run/bathy_plane_list.txt
echo run/left_bathy_b7_mask.tif run/right_bathy_b7_mask.tif > run/mask_list.txt

bundle_adjust                                              \
    run/left_bathy_b3_corr.tif run/right_bathy_b3_corr.tif \
    ../data/left_bathy.xml ../data/right_bathy.xml         \
    --bathy-mask-list run/mask_list.txt                    \
    --bathy-plane-list run/bathy_plane_list.txt            \
    --refraction-index $waterRefractionIndex               \
    --threads 1                                            \
    --num-iterations 10                                    \
    -o run/ba/run
stereo                                                     \
    run/left_bathy_b3_corr.tif run/right_bathy_b3_corr.tif \
    ../data/left_bathy.xml ../data/right_bathy.xml         \
    --left-bathy-mask run/left_bathy_b7_mask.tif           \
    --right-bathy-mask run/right_bathy_b7_mask.tif         \
    --bathy-plane-list run/bathy_plane_list.txt            \
    --refraction-index $waterRefractionIndex               \
    --bundle-adjust-prefix run/ba/run                      \
    run/run

point2dem run/run-PC.tif
