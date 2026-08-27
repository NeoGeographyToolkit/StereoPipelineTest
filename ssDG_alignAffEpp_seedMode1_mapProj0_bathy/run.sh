#!/bin/bash

set -x verbose
rm -rfv run

lthresh=300
rthresh=300
waterRefractionIndex=1.333

# Apply wv_correct
wv_correct --band 3 ../data/left_bathy_b3.tif ../data/left_bathy.xml run/left_bathy_b3_corr.tif
wv_correct --band 3 ../data/right_bathy_b3.tif ../data/right_bathy.xml run/right_bathy_b3_corr.tif

# Find the bathy plane using a DEM and a shapefile. --outlier-threshold is a
# distance in meters: a shoreline vertex counts as an inlier if its DEM height
# is within this of the fitted plane. The vertices scatter vertically by up to
# ~1.8 m about the water surface (DEM noise plus horizontal shoreline-tracing
# error over the sloped near-shore terrain), so the threshold must exceed that
# for all genuine waterline points to be kept. At 6 m all 9 vertices are inliers
# and the plane is fit to the full shoreline, coming out nearly horizontal
# (~0.1 deg tilt) as a water surface should be. The old 0.2 m was far below the
# scatter, so only 4 vertices survived and the plane was spuriously tilted.
bathy_plane_calc --shapefile ../data/bathy_shoreline.shp    \
    --dem ../data/dem_nobathy.tif --outlier-threshold 6.0   \
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

# Repeat the bathy run using a single georeferenced ortho land/water mask
# (--ortho-bathy-mask) instead of the separate left and right masks. This
# exercises the ortho-mask triangulation branch and should give nearly the
# same DEM as the run above.
#
# The two per-image masks carry a per-pair rule: a point gets the bathymetry
# correction only where BOTH the left and right masks call it water. A single
# ortho mask cannot express that, so combine the two mapprojected masks (same
# grid) into one that is water only where both are water: land = 1 where either
# mask is land (max > 0), water = 0 where both are water.
image_calc -c "gt(max(var_0, var_1), 0, 1, 0)" -d float32   \
    run/left_bathy_b3_corr.map.mask.tif                     \
    run/right_bathy_b3_corr.map.mask.tif                    \
    -o run/and_bathy_mask.tif

# Output under run/ so the gold captures it (gold is a copy of run/).
parallel_stereo                                             \
    ../data/left_bathy_b3_corr.map.tif                      \
    ../data/right_bathy_b3_corr.map.tif                     \
    ../data/left_bathy.xml ../data/right_bathy.xml          \
    --ortho-bathy-mask run/and_bathy_mask.tif               \
    --dem ../data/dem_nobathy.tif                           \
    --refraction-index 1.333                                \
    --bathy-plane run/bathy-plane.txt                       \
    --prev-run-prefix run/run                               \
    run/run_ortho/run

point2dem run/run_ortho/run-PC.tif
