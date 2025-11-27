#!/bin/bash

set -x verbose
rm -rfv run

# Align two images, then find the best ECEF transform between the corresponding DEM points
image_align                                                                 \
    ../data/zone10-CA_SanLuisResevoir-9m_crop_ned_shift_90_135_0.tif        \
    ../data/zone10-CA_SanLuisResevoir-9m_crop.tif                           \
    --alignment-transform translation                                       \
    --ecef-transform-type translation                                       \
    --dem1 ../data/zone10-CA_SanLuisResevoir-9m_crop_ned_shift_90_135_0.tif \
    --dem2 ../data/zone10-CA_SanLuisResevoir-9m_crop.tif                    \
    --output-prefix run/run                                                 \
    -o run/aligned_image2.tif

