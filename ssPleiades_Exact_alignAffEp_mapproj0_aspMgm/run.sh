#!/bin/bash

set -x verbose
rm -rfv run

parallel_stereo --allow-different-mapproject-gsd --corr-tile-size 5000 ../data/IMG_PHR1B_P_202204132246314_SEN_6304928201-1_R1C1_crop.TIF ../data/IMG_PHR1B_P_202204132247161_SEN_6304929201-1_R1C1_crop.tif ../data/DIM_PHR1B_P_202204132246314_SEN_6304928201-1.XML ../data/DIM_PHR1B_P_202204132247161_SEN_6304929201-1.XML --stereo-algorithm asp_mgm run/run --propagate-errors --left-image-crop-win 595 474 450 450 --right-image-crop-win 619 465 400 500

point2dem --propagate-errors --stereographic --proj-lon 0 --proj-lat 90 --errorimage run/run-PC.tif

# Mapproject
mapproject run/run-DEM.tif ../data/IMG_PHR1B_P_202204132246314_SEN_6304928201-1_R1C1_crop.TIF ../data/DIM_PHR1B_P_202204132246314_SEN_6304928201-1.XML run/left_proj.tif
mapproject run/run-DEM.tif ../data/IMG_PHR1B_P_202204132247161_SEN_6304929201-1_R1C1_crop.tif ../data/DIM_PHR1B_P_202204132247161_SEN_6304929201-1.XML --tr 0.534364640712738 run/right_proj.tif

# Run with mapprojected images as well
parallel_stereo --stereo-algorithm asp_mgm --allow-different-mapproject-gsd run/left_proj.tif run/right_proj.tif ../data/DIM_PHR1B_P_202204132246314_SEN_6304928201-1.XML ../data/DIM_PHR1B_P_202204132247161_SEN_6304929201-1.XML run/run-proj run/run-DEM.tif --propagate-errors 
point2dem --stereographic --proj-lon 0 --proj-lat 90 --errorimage --propagate-errors run/run-proj-PC.tif

