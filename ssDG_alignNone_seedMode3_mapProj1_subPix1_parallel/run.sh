#!/bin/bash

set -x verbose
rm -rfv run


parallel_stereo --processes 8 --threads-multiprocess 1 --job-size-w 512 --job-size-h 1024 ../data/WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m_sub2_crop1.tif ../data/WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m_sub2_crop1.tif ../data/WV01_11JAN131652222-P1BS-10200100104A0300.xml ../data/WV01_11JAN131653180-P1BS-1020010011862E00.xml run/run ../data/krigged_dem_nsidc_ndv0_fill.tif --left-image-crop-win 0 2048 1024 1024 --corr-search -30 -30 30 30 --corr-max-levels 5 -s stereo.default --disable-fill-holes  -t dg --alignment-method none --corr-seed-mode 3 --subpixel-mode 1 
point2dem -r Earth run/run-PC.tif --nodata-value -32767


