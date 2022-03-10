#!/bin/bash

set -x verbose
rm -rfv run

stereo --corr-timeout 6000 ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc_5mpp.tif ../data/09OCT11191503-P1BS_R1C1-052783426010_01_P001_rpc.xml ../data/09OCT11191555-P1BS_R1C1-052783426010_01_P001_rpc.xml run/run ../data/zone10-CA_SanLuisResevoir-9m.tif --corr-max-levels 5 -t dg -s stereo.default --alignment-method none --subpixel-mode 1 --disable-fill-holes --threads 32 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --corr-seed-mode 1 --left-image-crop-win 1024 1024 1024 2048 --save-left-right-disparity-difference

point2dem -r Earth run/run-PC.tif --nodata-value -32767 --tr 10 --t_projwin 662622 4097852 665652 4093592


