#!/bin/bash

# bundle_adjust with --propagate-errors and bathymetry. The DG satellite
# ephemeris/attitude covariance is propagated to the triangulated interest
# points through the bent-ray triangulation, so underwater matches get a larger
# vertical uncertainty. Dense matches from the stereo disparity give enough
# points over the (bland) water. See docs/error_propagation.rst.

set -x verbose
rm -rfv run
mkdir -p run

lthresh=300
rthresh=300

# Raw land/water masks (0 in water, 1 on land) from the raw green band.
image_calc -c "sign(max($lthresh, var_0)-$lthresh)" --output-nodata-value -1 \
    ../data/left_bathy_b3.tif  -o run/left_mask.tif
image_calc -c "sign(max($rthresh, var_0)-$rthresh)" --output-nodata-value -1 \
    ../data/right_bathy_b3.tif -o run/right_mask.tif

# Water-surface plane.
bathy_plane_calc --dem ../data/dem_nobathy.tif       \
    --mask run/left_mask.tif                          \
    --camera ../data/left_bathy.xml                   \
    --bathy-plane run/bathy-plane.txt                 \
    --outlier-threshold 6.0                           \
    --num-samples 10000

# Dense matches from the disparity, on a small crop with both water and land. The
# right crop is offset by the local disparity (about 762 rows) so the small
# windows overlap. Plain stereo with block matching is used, as only matches are
# needed here, not high correlation quality.
stereo -t dg                                          \
    ../data/left_bathy_b3.tif ../data/right_bathy_b3.tif \
    ../data/left_bathy.xml ../data/right_bathy.xml     \
    --alignment-method affineepipolar                 \
    --stereo-algorithm asp_bm --subpixel-mode 1        \
    --left-image-crop-win  0 3600 350 350             \
    --right-image-crop-win 0 4280 370 500             \
    --num-matches-from-disparity 1000 --matches-as-txt \
    run/stereo

# bundle_adjust with the dense matches, bathymetry, and error propagation.
printf "run/left_mask.tif\nrun/right_mask.tif\n" > run/masks.txt
bundle_adjust -t dg                                   \
    ../data/left_bathy_b3.tif ../data/right_bathy_b3.tif \
    ../data/left_bathy.xml ../data/right_bathy.xml     \
    --match-files-prefix run/stereo-disp --matches-as-txt \
    --num-passes 2 --max-iterations 100               \
    --propagate-errors                                \
    --bathy-mask-list run/masks.txt                   \
    --bathy-plane run/bathy-plane.txt                 \
    --refraction-index 1.34                           \
    -o run/ba
