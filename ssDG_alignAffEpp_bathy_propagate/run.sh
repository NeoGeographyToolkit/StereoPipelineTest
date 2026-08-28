#!/bin/bash

# Error propagation (--propagate-errors) together with bathymetry, on raw
# (non-mapprojected) images with raw land/water masks. The DG satellite
# ephemeris/attitude covariance is propagated through the bent-ray
# triangulation. Over water the vertical stddev grows relative to land, where
# the rays are not bent. See docs/error_propagation.rst and bathymetry.rst.

set -x verbose
rm -rfv run
mkdir -p run

lthresh=300
rthresh=300

# Raw land/water masks (0 in water, 1 on land) from the raw green band.
image_calc -c "sign(max($lthresh, var_0)-$lthresh)" --output-nodata-value -1 \
    ../data/left_bathy_b3.tif  -o run/left_bathy_b3.mask.tif
image_calc -c "sign(max($rthresh, var_0)-$rthresh)" --output-nodata-value -1 \
    ../data/right_bathy_b3.tif -o run/right_bathy_b3.mask.tif

# Water-surface plane from the DEM, the raw mask, and the camera. The 6 m
# outlier threshold keeps the full shoreline (the vertices scatter by up to
# ~1.8 m about the water surface), giving a near-horizontal plane.
bathy_plane_calc --dem ../data/dem_nobathy.tif       \
    --mask run/left_bathy_b3.mask.tif                \
    --camera ../data/left_bathy.xml                  \
    --bathy-plane run/bathy-plane.txt                \
    --outlier-threshold 6.0                          \
    --num-samples 10000

# Stereo with bathymetry and error propagation. The crop keeps a small land+water
# strip so both the unchanged land stddev and the depth-amplified water stddev are
# exercised. The right crop is offset by the local disparity (about 762 rows) so
# the small windows overlap. Plain stereo with block matching is used, as the test
# only needs points to triangulate, not high correlation quality.
stereo                                                \
    ../data/left_bathy_b3.tif                         \
    ../data/right_bathy_b3.tif                        \
    ../data/left_bathy.xml ../data/right_bathy.xml    \
    --alignment-method affineepipolar                 \
    --stereo-algorithm asp_bm --subpixel-mode 1       \
    --left-image-crop-win  0 3600 350 350             \
    --right-image-crop-win 0 4280 370 500             \
    --left-bathy-mask  run/left_bathy_b3.mask.tif     \
    --right-bathy-mask run/right_bathy_b3.mask.tif    \
    --refraction-index 1.333                          \
    --bathy-plane run/bathy-plane.txt                 \
    --propagate-errors                                \
    run/run

# Pin the grid size so the gold is deterministic across platforms.
point2dem run/run-PC.tif --propagate-errors --tr 8.6
