#!/bin/bash

set -x verbose
rm -rfv run

stereo --enable-fill-holes ../data/WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m_sub2_crop1.tif ../data/WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m_sub2_crop1.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml ../data/WV01_11JAN131653180-P1BS-1020010011862E00.xml run/run ../data/krigged_dem_nsidc_ndv0_fill.tif --left-image-crop-win 0 2048 512 512 --corr-search -30 -30 30 30 --subpixel-mode 1 --alignment-method none --erode-max-size 1000
point2dem -r Earth run/run-PC.tif --nodata-value -32767


