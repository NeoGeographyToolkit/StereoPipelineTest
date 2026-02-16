#!/bin/bash

set -x verbose
rm -rfv run

lthresh=171.4873
rthresh=180.2035
waterRefractionIndex=1.333

# Apply wv_correct
wv_correct --band 3 ../data/left_bathy_b3.tif ../data/left_bathy.xml run/left_bathy_b3_corr.tif
wv_correct --band 3 ../data/right_bathy_b3.tif ../data/right_bathy.xml run/right_bathy_b3_corr.tif

# For speed the we cached the DEM produced with this as ../data/dem_nobathy.tif
# # First run with no bathymetry
# stereo run/left_bathy_b3_corr.tif run/right_bathy_b3_corr.tif \
#     ../data/left_bathy.xml ../data/right_bathy.xml            \
#     run/run-nobathy
# point2dem run/run-nobathy-PC.tif --orthoimage run/run-nobathy-L.tif 

# Find the bathy plane using a DEM and a shapefile
bathy_plane_calc --shapefile ../data/bathy_shoreline.shp    \
    --dem ../data/dem_nobathy.tif --outlier-threshold 0.2   \
    --bathy-plane run/bathy-plane.txt                       \
	--output-inlier-shapefile run/inliers.shp  

# Find the bathy plane using a DEM, a mask, and a camera.
# The mask was moved o the data dir for speed.
bathy_plane_calc --dem ../data/dem_nobathy.tif       \
  --mask ../data/left_bathy_b3_corr.mask.tif         \
  --camera ../data/left_bathy.xml                    \
  --bathy-plane run/mask-bathy-plane.txt             \
  --outlier-threshold 0.5                            \
  --output-inlier-shapefile run/run-mask-inliers.shp \
  --num-samples 10000

# Run bathy threshold estimation. Need extra Python modules for that.
~oalexan1/miniconda3/envs/bathy/bin/python $(which bathy_threshold_calc.py) \
    --image ../data/left_bathy_b7.tif --num-samples 100000                  \
    --no-plot | grep -v -i elapsed > run/run-threshold.txt

# Mapproject so we can run stereo on one clip. 
# win="421832 2719241 422797 2718340"
# mapproject                      \
#     --tr 2.0                    \
#     --t_projwin $win            \
#     ../data/dem_nobathy.tif     \
#     run/left_bathy_b3_corr.tif  \
#     ../data/left_bathy.xml      \
#     run/left_bathy_b3_corr.map.tif
# mapproject                      \
#     --tr 2.0                    \
#     --t_projwin $win            \
#     ../data/dem_nobathy.tif     \
#     run/right_bathy_b3_corr.tif \
#     ../data/right_bathy.xml     \
#     run/right_bathy_b3_corr.map.tif
# The results were moved to the data dir for speed.

# Masks
image_calc -c "max($lthresh, var_0)" --output-nodata-value $lthresh \
    ../data/left_bathy_b3_corr.map.tif -o run/left_bathy_b3_corr.map.mask.tif
image_calc -c "max($rthresh, var_0)" --output-nodata-value $rthresh \
    ../data/right_bathy_b3_corr.map.tif -o run/right_bathy_b3_corr.map.mask.tif

# Run with bathy on a cip
parallel_stereo                                             \
    ../data/left_bathy_b3_corr.map.tif                      \
    ../data/right_bathy_b3_corr.map.tif                     \
    ../data/left_bathy.xml ../data/right_bathy.xml          \
    --left-bathy-mask run/left_bathy_b3_corr.map.mask.tif   \
    --right-bathy-mask run/right_bathy_b3_corr.map.mask.tif \
    --dem ../data/dem_nobathy.tif                           \
    --refraction-index 1.333                                \
    --bathy-plane run/bathy-plane.txt                       \
    run/run

point2dem run/run-PC.tif
