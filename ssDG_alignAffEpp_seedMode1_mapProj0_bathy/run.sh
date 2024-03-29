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

# First run with no bathymetry
stereo run/left_bathy_b3_corr.tif run/right_bathy_b3_corr.tif \
    ../data/left_bathy.xml ../data/right_bathy.xml            \
    run/run-nobathy
point2dem run/run-nobathy-PC.tif --orthoimage run/run-nobathy-L.tif 

#    --left-image-crop-win -415 3295 1724 1844               \
#    --right-image-crop-win -189 3895 1413 1258              \

# Find the bathy plane using a DEM and a shapefile
bathy_plane_calc --shapefile ../data/bathy_shoreline.shp    \
    --dem run/run-nobathy-DEM.tif --outlier-threshold 0.2   \
    --bathy-plane run/bathy-plane.txt                       \
	--output-inlier-shapefile run/inliers.shp  

# Find the bathy plane using a DEM, a mask, and a camera
bathy_plane_calc --dem run/run-nobathy-DEM.tif       \
  --mask run/left_bathy_b7_mask.tif                  \
  --camera ../data/left_bathy.xml                    \
  --bathy-plane run/mask-bathy-plane.txt             \
  --outlier-threshold 0.5                            \
  --output-inlier-shapefile run/run-mask-inliers.shp \
  --num-samples 10000

#    --left-image-crop-win -415 3295 1724 1844               \
#    --right-image-crop-win -189 3895 1413 1258              \

# Run with bathy with --prev-run-prefix
parallel_stereo run/left_bathy_b3_corr.tif         \
    run/right_bathy_b3_corr.tif                    \
    ../data/left_bathy.xml ../data/right_bathy.xml \
    --left-bathy-mask run/left_bathy_b7_mask.tif   \
    --right-bathy-mask run/right_bathy_b7_mask.tif \
    --refraction-index 1.333                       \
    --bathy-plane run/bathy-plane.txt              \
    --prev-run-prefix run/run-nobathy run/run

point2dem run/run-PC.tif

# Also run bathy threshold estimation. Need extra Python modules for that.
~oalexan1/miniconda3/envs/bathy/bin/python $(which bathy_threshold_calc.py) \
    --image ../data/left_bathy_b7.tif --num-samples 100000                  \
    --no-plot | grep -v -i elapsed > run/run-threshold.txt

