#!/bin/bash

set -x verbose
rm -rfv run

lthresh=300
rthresh=300
waterRefractionIndex=1.333

# Apply wv_correct
wv_correct --band 3 ../data/left_bathy_b3.tif ../data/left_bathy.xml run/left_bathy_b3_corr.tif
wv_correct --band 3 ../data/right_bathy_b3.tif ../data/right_bathy.xml run/right_bathy_b3_corr.tif

# Find the bathy plane using a DEM and a shapefile. The outlier threshold is a
# distance in meters and should be comparable to the DEM ground sample distance
# (here about 2 m), not far below it.
bathy_plane_calc --shapefile ../data/bathy_shoreline.shp    \
    --dem ../data/dem_nobathy.tif --outlier-threshold 1.0   \
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

# The water-land threshold estimation (bathy_threshold_calc.py) is tested
# separately in ss_bathy_threshold_calc, as it needs an extra Python env.

# Form masks with 0 in water and 1 on land
image_calc -c "sign(max($lthresh, var_0)-$lthresh)" --output-nodata-value -1 \
    ../data/left_bathy_b3_corr.map.tif -o run/left_bathy_b3_corr.map.mask.tif
image_calc -c "sign(max($rthresh, var_0)-$rthresh)" --output-nodata-value -1 \
    ../data/right_bathy_b3_corr.map.tif -o run/right_bathy_b3_corr.map.mask.tif

# This shows how mapprojection was done, which is needed for the command below.
# The results were moved to the data dir for speed.
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

# Run with bathy on a clip
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
