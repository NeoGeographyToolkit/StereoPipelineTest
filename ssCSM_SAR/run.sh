#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo ../data/lsz_03821_1cd_xku_16n196_v1_clamp_crop.tif ../data/lsz_03822_1cd_xku_23n196_v1_clamp_crop.tif ../data/lsz_03821_1cd_xku_16n196_v1.json ../data/lsz_03822_1cd_xku_23n196_v1.json --stereo-algorithm asp_mgm --skip-rough-homography --no-datum --ip-per-tile 6000 --left-image-crop-win 469 8005 1831 1822 --right-image-crop-win 562 27190 1404 1696 run/run

point2dem run/run-PC.tif

# Fill holes. There are a lot of them.
dem_mosaic --dem-blur-sigma 10 run/run-DEM.tif -o run/run-DEM-blur.tif

# Now test bundle adjustment. It is tricky to find match points, that is why 
# use mapprojection after stereo

mapproject run/run-DEM-blur.tif ../data/lsz_03821_1cd_xku_16n196_v1_clamp_crop.tif ../data/lsz_03821_1cd_xku_16n196_v1.json run/lsz_03821_1cd_xku_16n196_v1.map.tif --t_projwin 196.277 22.247 196.611 21.847 --tr 0.00037

mapproject run/run-DEM-blur.tif ../data/lsz_03822_1cd_xku_23n196_v1_clamp_crop.tif ../data/lsz_03822_1cd_xku_23n196_v1.json run/lsz_03822_1cd_xku_23n196_v1.map.tif --t_projwin 196.277 22.247 196.611 21.847 --tr 0.00037

bundle_adjust ../data/lsz_03821_1cd_xku_16n196_v1_clamp_crop.tif ../data/lsz_03822_1cd_xku_23n196_v1_clamp_crop.tif ../data/lsz_03821_1cd_xku_16n196_v1.json ../data/lsz_03822_1cd_xku_23n196_v1.json --mapprojected-data "run/lsz_03821_1cd_xku_16n196_v1.map.tif run/lsz_03822_1cd_xku_23n196_v1.map.tif run/run-DEM-blur.tif" -o run/ba/run --ip-per-tile 60000 --matches-per-tile 60000 --threads 1 --min-matches 5 --remove-outliers-params '3 75 10000 10000' --num-iterations 10

# Second bundle adjustment, to see if we can load back the state.
# This run does not like the previously created match points much. Need to figure out why.
bundle_adjust ../data/lsz_03821_1cd_xku_16n196_v1_clamp_crop.tif ../data/lsz_03822_1cd_xku_23n196_v1_clamp_crop.tif run/ba/run-lsz_03821_1cd_xku_16n196_v1.adjusted_state.json run/ba/run-lsz_03822_1cd_xku_23n196_v1.adjusted_state.json --mapprojected-data "run/lsz_03821_1cd_xku_16n196_v1.map.tif run/lsz_03822_1cd_xku_23n196_v1.map.tif run/run-DEM-blur.tif" -o run/ba_state/run --ip-per-tile 20000 --threads 1 --num-iterations 10 --match-files-prefix run/ba/run  --remove-outliers-params '3 75 100 100' --num-passes 1  --forced-triangulation-distance 100000

